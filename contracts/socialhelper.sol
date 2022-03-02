// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./postfactory.sol";
import "./userfactory.sol";
import "./safemaths.sol";

contract SocialHelper is PostFactory, UserFactory {

  using SafeMath for uint256;
  using SafeMath32 for uint32;
  using SafeMath16 for uint16;

  uint txFee = 0.01 ether;

  modifier aboveLikes(uint _likes, uint _postId) {
    require(postsMap[_postId].likes >= _likes);
    _;
  }

  modifier aboveFollowers(uint _followers, uint _userId) {
    require(usersMap[_userId].followers >= _followers);
    _;
  }

  modifier canOnlyLikeOnce(uint _postId) {
    uint followeeId = ownerToUserId[msg.sender];
    require(postsMap[_postId].likesMap[followeeId] = false);
    _;
  }

  function withdraw() external onlyOwner {
    address _owner = owner();
    payable(_owner).transfer(address(this).balance);
  }

  function setTxFee(uint _fee) external onlyOwner {
    txFee = _fee;
  }

  function likePost(uint _postId) external payable canOnlyLikeOnce(_postId) {
    require(msg.value >= txFee);
    postsMap[_postId].likes = postsMap[_postId].likes.add(1);
    address postOwner = postToOwner[_postId];
    uint postOwnerUserId = ownerToUserId[postOwner];

    uint callerUserId = ownerToUserId[msg.sender];
    postsMap[_postId].likesMap[callerUserId] = true;

    uint fundsForOwner = msg.value.div(100).mul(98); // 2% cut for rebel
    payable(postOwner).transfer(fundsForOwner);
    usersMap[postOwnerUserId].amtEarned = usersMap[postOwnerUserId].amtEarned.add(fundsForOwner);
  }

  function unlikePost(uint _postId) external {
    postsMap[_postId].likes = postsMap[_postId].likes.sub(1);

    uint callerUserId = ownerToUserId[msg.sender];
    postsMap[_postId].likesMap[callerUserId] = false;
  }

  function followUser(uint _userId) external payable {
    require(msg.value >= txFee);
    usersMap[_userId].followers = usersMap[_userId].followers.add(1);
    uint followeeId = ownerToUserId[msg.sender];
    User storage user = usersMap[followeeId];
    user.following = user.following.add(1);
    address userOwner = userToOwner[_userId];

    usersMap[_userId].followersMap[followeeId] = true;
    usersMap[followeeId].followingMap[_userId] = true;

    uint fundsForOwner = msg.value.div(100).mul(98); // 2% cut for rebel
    payable(userOwner).transfer(fundsForOwner);

    usersMap[_userId].amtEarned = usersMap[_userId].amtEarned.add(fundsForOwner);
  }

  function unfollowUser(uint _userId) external {
    usersMap[_userId].followers = usersMap[_userId].followers.sub(1);
    uint followeeId = ownerToUserId[msg.sender];
    User storage user = usersMap[followeeId];
    user.following = user.following.sub(1);

    usersMap[_userId].followersMap[followeeId] = false;
    usersMap[followeeId].followingMap[_userId] = false;
  }

  function changeName(uint _userId, string memory _newName) external onlyOwner() {
    usersMap[_userId].name = _newName;
  }

  function changeBio(uint _userId, string memory _newBio) external onlyOwner() {
    usersMap[_userId].bio = _newBio;
  }

  function changeProfPic(uint _userId, string memory _profPicHash) external onlyOwner() {
    usersMap[_userId].profPicHash = _profPicHash;
  }

  function getPostsByOwner(address _owner) external view returns(
    string[] memory namesArray,
    string[] memory mediaHashesArray,
    string[] memory metaHashesArray,
    uint[] memory likesArray,
    bool[] memory blacklistedArray,
    uint[] memory idArray
    ) {
    uint[] memory postIds = ownerToPostIds[_owner];
    string[] memory names = new string[](postIds.length);
    string[] memory mediaHashes = new string[](postIds.length);
    string[] memory metaHashes = new string[](postIds.length);
    uint[] memory likes = new uint[](postIds.length);
    bool[] memory blacklisted = new bool[](postIds.length);

    for (uint i = 0; i < postIds.length; i++) {
        Post storage post = postsMap[postIds[i]];
        names[i] = post.name;
        mediaHashes[i] = post.mediaHash;
        metaHashes[i] = post.metaHash;
        likes[i] = post.likes;
        blacklisted[i] = post.blacklisted;
    }

    return (names, mediaHashes, metaHashes, likes, blacklisted, postIds);
  }

  function getPostsByIds(uint[] memory _postIds) external view returns(
    string[] memory namesArray,
    string[] memory mediaHashesArray,
    string[] memory metaHashesArray,
    uint[] memory likesArray,
    bool[] memory blacklistedArray,
    uint[] memory idArray
  ) {
    string[] memory names = new string[](_postIds.length);
    string[] memory mediaHashes = new string[](_postIds.length);
    string[] memory metaHashes = new string[](_postIds.length);
    uint[] memory likes = new uint[](_postIds.length);
    bool[] memory blacklisted = new bool[](_postIds.length);
    uint[] memory ids = _postIds;

    for (uint i = 0; i < ids.length; i++) {
      Post storage post = postsMap[ids[i]];
      names[i] = post.name;
      mediaHashes[i] = post.mediaHash;
      metaHashes[i] = post.metaHash;
      likes[i] = post.likes;
      blacklisted[i] = post.blacklisted;
    }

    return (names, mediaHashes, metaHashes, likes, blacklisted, ids);
  }

  function getUserByOwner(address _owner) external view returns(
    string memory name,
    string memory bio,
    uint followers,
    uint following,
    string memory profPicHash,
    uint amtEarned,
    bool blacklisted,
    uint postCount,
    uint id
  ) {
    uint userId = ownerToUserId[_owner];
    User storage user = usersMap[userId];
    uint postTotal = ownerPostCount[_owner];

    return (user.name, user.bio, user.followers, user.following, user.profPicHash, user.amtEarned, user.blacklisted, postTotal, userId);
  }

  function getUsersByIds(uint[] memory _userIds) external view returns(
    string[] memory nameArray,
    string[] memory bioArray,
    uint[] memory followersArray,
    uint[] memory followingArray,
    string[] memory profPicHashArray,
    bool[] memory blacklistArray,
    uint[] memory idArray
  ) {
    string[] memory names = new string[](_userIds.length);
    string[] memory bios = new string[](_userIds.length);
    uint[] memory followers = new uint[](_userIds.length);
    uint[] memory following = new uint[](_userIds.length);
    string[] memory profPicHashes = new string[](_userIds.length);
    bool[] memory blacklist = new bool[](_userIds.length);
    uint[] memory ids = _userIds;

    for (uint i = 0; i < ids.length; i++) {
      User storage user = usersMap[ids[i]];
      names[i] = user.name;
      bios[i] = user.bio;
      followers[i] = user.followers;
      following[i] = user.following;
      profPicHashes[i] = user.profPicHash;
      blacklist[i] = user.blacklisted;
    }

    return (names, bios, followers, following, profPicHashes, blacklist, ids);
  }

  function isFollowing(uint userId) external view returns(
    bool following
  ) {
    User storage user = usersMap[userId];
    uint callerUserId = ownerToUserId[msg.sender];

    return (user.followersMap[callerUserId]);
  }

  function isLiked(uint[] memory postIds) external view returns(
    bool[] memory likedArray
  ) {
    bool[] memory likesList = new bool[](postIds.length);

    for (uint i = 0; i < postIds.length; i++) {
      Post storage post = postsMap[postIds[i]];
      uint callerUserId = ownerToUserId[msg.sender];
      likesList[i] = post.likesMap[callerUserId];
    }

    return (likesList);
  }

}