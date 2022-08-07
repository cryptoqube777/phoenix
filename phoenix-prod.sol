// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)

pragma solidity ^0.8.1;

/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     *
     * [IMPORTANT]
     * ====
     * You shouldn't rely on `isContract` to protect against flash loan attacks!
     *
     * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
     * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
     * constructor.
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize/address.code.length, which returns 0
        // for contracts in construction, since the code is only stored at the end
        // of the constructor execution.

        return account.code.length > 0;
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain `call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCall(target, data, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");

        (bool success, bytes memory returndata) = target.call{value: value}(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        (bool success, bytes memory returndata) = target.staticcall(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");

        (bool success, bytes memory returndata) = target.delegatecall(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
     * revert reason using the provided one.
     *
     * _Available since v4.3._
     */
    function verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}


/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}


/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor(address initialOwner) {
        _transferOwnership(initialOwner);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}


/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 *
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 */
abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor() {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and making it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        // On the first call to nonReentrant, _notEntered will be true
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;

        _;

        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }
}



contract Phoenix is Ownable, ReentrancyGuard {
    using Address for address;

    struct User {
        uint256 id;
        address referral;
        uint256 refCount;
        uint256 earned;
        bool isLeader;
        bool isActive;
        uint256 claimed;
        uint256 regDate;
    }

    mapping (address => User) public users;

    mapping (uint256 => address) public _idToAddress;

    mapping (address => mapping (uint256 => bool)) public _isActive;

    mapping (address => mapping (uint256 => address)) public _uplines;

    mapping (address => mapping (uint256 => address[])) public _matrix;

    address[] private _leaders;

    uint256[64] public _prices = [
                                    6000000000000000000,
                                    5200000000000000000,
                                    4400000000000000000,
                                    3200000000000000000,
                                    2200000000000000000,
                                    1600000000000000000,
                                    1100000000000000000,
                                    800000000000000000,
                                    550000000000000000,
                                    400000000000000000,
                                    280000000000000000,
                                    200000000000000000,
                                    140000000000000000,
                                    100000000000000000,
                                    70000000000000000,
                                    50000000000000000,
                                    1000000000000000000,
                                    1100000000000000000,
                                    1210000000000000000,
                                    1330000000000000000,
                                    1470000000000000000,
                                    1620000000000000000,
                                    1780000000000000000,
                                    1960000000000000000,
                                    2160000000000000000,
                                    2380000000000000000,
                                    2620000000000000000,
                                    2880000000000000000,
                                    3170000000000000000,
                                    3490000000000000000,
                                    3840000000000000000,
                                    4230000000000000000,
                                    4650000000000000000,
                                    5120000000000000000,
                                    5630000000000000000,
                                    6200000000000000000,
                                    6820000000000000000,
                                    7500000000000000000,
                                    8250000000000000000,
                                    9000000000000000000,
                                    10000000000000000000,
                                    11000000000000000000,
                                    12100000000000000000,
                                    13300000000000000000,
                                    14700000000000000000,
                                    16200000000000000000,
                                    17800000000000000000,
                                    19600000000000000000,
                                    21600000000000000000,
                                    23800000000000000000,
                                    26200000000000000000,
                                    28800000000000000000,
                                    31700000000000000000,
                                    34900000000000000000,
                                    38400000000000000000,
                                    42300000000000000000,
                                    46500000000000000000,
                                    51200000000000000000,
                                    56300000000000000000,
                                    62000000000000000000,
                                    68200000000000000000,
                                    75000000000000000000,
                                    82500000000000000000,
                                    90000000000000000000
                                ];

    uint256[64] public _revealDates = [
                                        1662051600, 1662094800, 1662138000, 1662181200, 1662224400, 1662310800, 1662397200, 1662483600, 1662570000, 1662742800,
                                        1662915600, 1663088400, 1663261200, 1663520400, 1663779600, 1664038800, 1664125200, 1664298000, 1664470800, 1664643600,
                                        1664816400, 1664989200, 1665162000, 1665334800, 1665507600, 1665680400, 1665853200, 1666026000, 1666198800, 1666371600,
                                        1666544400, 1666717200, 1666890000, 1667062800, 1667239200, 1667412000, 1667584800, 1667757600, 1667930400, 1668103200,
                                        1664125200, 1664298000, 1664470800, 1664643600, 1664816400, 1664989200, 1665162000, 1665334800, 1665507600, 1665680400,
                                        1665853200, 1666026000, 1666198800, 1666371600, 1666544400, 1666717200, 1666890000, 1667062800, 1667239200, 1667412000,
                                        1667584800, 1667757600, 1667930400, 1668103200
                                    ];



    address private _developerWallet = 0xA6300af0653fc8ebc9f527376EC9882344D37D7b;

    uint256 private _developerFee = 2;

    address[2] private _platformWallet = [0x34742629108AcE4d4a5aDC1764Fd2a08db52Dc50, 0x259d5879d4A4BFf7C315ae6e8Cd3f75Db1022d8B];

    uint256 public _lastUserId;

    uint256 private _activeUsers;

    uint256 public _poolFee = 5;

    uint256 private _poolAmount;

    event Register(address indexed _account, uint256 _id, address indexed _referral);

    event Payment(address indexed _account, string purpose, uint256 amount);

    event UplineFound(address indexed upline, uint256 level);

    event RewardClaimed(address indexed _account, uint256 amount);

    event BonusAdded(uint256 amount);

    constructor(address initialOwner) Ownable(initialOwner) {
    }

    /**
     * @dev Turns on/of a leader status of a wallet.
     *
     * @param account - wallet of user
     * @param isLeader - true/false status
     *
     * Requirements:
     *
     * - 'account' must not be a zero address.
     * - 'account' must be registered
     *
     */
    function setLeader(address account, bool isLeader) external onlyOwner {
        require(account != address(0), "Zero address not allowed");
        require(users[account].id > 0, "User is not registered");
        if (users[account].isLeader && !isLeader) {
            users[account].isLeader = false;
            for (uint i=0; i < _leaders.length; i++) {
                if (_leaders[i] == account) {
                    _leaders[i] = _leaders[_leaders.length - 1];
                    _leaders.pop();
                    break;
                }

            }
        } else if (!users[account].isLeader && isLeader) {
            _leaders.push(account);
            users[account].isLeader = true;
        }

    }

    /**
     * @dev Set/change addresses of platform wallets, used in payment distribution
     *
     * @param accounts - array of 2 wallet addresses
     *
     * Requirements:
     *
     * - none of two wallets should be a zero address.
     */
    function setPlatformWallets(address[2] calldata accounts) external onlyOwner {
        require((accounts[0] != address(0) && accounts[1] != address(0)), "Zero addresses not allowed");
        _platformWallet[0] = accounts[0];
        _platformWallet[1] = accounts[1];
    }

    /**
     * @dev Registration of new leaders.
     *
     * Emits an {Register} event.
     *
     * @param accounts - array of user wallets
     *
     */
    function addLeaders(address[] calldata accounts) external onlyOwner {
        for (uint i = 0; i < accounts.length; i++) {
            if (accounts[i] == address(0) || users[accounts[i]].id > 0) {
                continue;
            }
            _lastUserId += 1;
            User memory user = User({
                                    id: _lastUserId,
                                    referral: address(0),
                                    refCount: 0,
                                    earned: 0,
                                    isLeader: true,
                                    isActive: false,
                                    claimed: 0,
                                    regDate: block.timestamp
                                  });
            users[accounts[i]] = user;
            _idToAddress[_lastUserId] = accounts[i];
            _leaders.push(accounts[i]);
            emit Register(accounts[i], _lastUserId, address(0));
        }
    }

    /**
     * @dev Removes leader status from accounts in a list
     *
     * @param accounts - array of wallets
     *
     */
    function removeLeaders(address[] calldata accounts) external onlyOwner {
        for (uint i = 0; i < accounts.length; i++) {
            if (users[accounts[i]].id > 0 && users[accounts[i]].isLeader) {
                users[accounts[i]].isLeader = false;
                for (uint j = 0; j < _leaders.length; j++) {
                    if (_leaders[j] == accounts[i]) {
                        _leaders[j] = _leaders[_leaders.length - 1];
                        _leaders.pop();
                        break;
                    }
                }
            }
        }
    }

    /**
     * @dev Returns array of all registered leader's wallets and their earnings.
     *
     *
     */
    function getLeaders() public view returns(address[] memory, uint256[] memory) {
        address[] memory wallets = new address[](_leaders.length);
        uint256[] memory amounts = new uint256[](_leaders.length);
        for (uint i = 0; i < _leaders.length; i++) {
            wallets[i] = _leaders[i];
            amounts[i] = users[_leaders[i]].earned;
        }
        return (wallets, amounts);
    }

    /**
     * @dev Returns details about specific user account.
     *
     *
     * @param
     * - 'account' - wallet of user
     *
     * Requirements:
     *
     * - 'account' must not be a zero address.
     *
     */
    function getUserData(address account) public view returns ( uint256, //id
                                                                bool, // is leader
                                                                address, // referral wallet
                                                                uint256, // count of referring users
                                                                uint256, // registration date
                                                                uint256, // total earned BNB amount
                                                                bool[] memory // active levels
                                                            )
    {
        require(account != address(0), "Zero address prohibited");
        bool[] memory activeLevels = new bool[](64);
        for (uint i = 0; i < 64; i++) {
            if (users[account].isLeader || _isActive[account][i]) {
                activeLevels[i] = true;
            } else {
                activeLevels[i] = false;
            }
        }
        return (
                    users[account].id,
                    users[account].isLeader,
                    users[account].referral,
                    users[account].refCount,
                    users[account].regDate,
                    users[account].earned, activeLevels
                );
    }

    /**
     * @dev Checks if user was registered. Returns true or false
     *
     * @param
     * - 'account' - wallet of user
     *
     */
    function isUserRegistered(address account) public view returns (bool) {
        if (users[account].id > 0) {
            return true;
        } else {
            return false;
        }
    }

    /**
     * @dev Registration of a new user.
     *
     * Emits an {Register} event.
     *
     * @param ref - wallet of refferal
     *
     * Requirements:
     *
     * - caller must not be registered.
     * - 'ref' address cannot be a zero wallet
     * - 'ref' wallet must be registered.
     *
     */
    function register(address ref) public {
        require(users[_msgSender()].id == 0, "User is already registered");
        require(ref != address(0), "Zero referral address is prohibited");
        require(users[ref].id > 0, "Referral is not registered");
        _lastUserId += 1;
        User memory user = User({
                                    id: _lastUserId,
                                    referral: ref,
                                    refCount: 0,
                                    earned: 0,
                                    isLeader: false,
                                    isActive: false,
                                    claimed: 0,
                                    regDate: block.timestamp
                                  });
        users[_msgSender()] = user;
        _idToAddress[_lastUserId] = _msgSender();
        users[ref].refCount += 1;
        emit Register(_msgSender(), _lastUserId, ref);
    }

    /**
     * @dev Internal function used to find free place in upline matrix to place new user to.
     *
     * @param
     * - 'account' - wallet of new user
     * - 'level' - number of level bought (0 - 63)
     *
     */
    function findFreePlace(address account, uint256 level) internal view returns (address) {
        address ref = users[account].referral;
        if (users[ref].isLeader) {
            return address(0);
        }
        if (!_isActive[ref][level]) {
            return address(0);
        } else if (_matrix[ref][level].length < 2) {
            return ref;
        } else if (_matrix[_matrix[ref][level][0]][level].length < 2) {
            return _matrix[ref][level][0];
        } else if (_matrix[_matrix[ref][level][1]][level].length < 2) {
            return _matrix[ref][level][1];
        } else {
            return address(0);
        }
    }

    /**
     * @dev Internal function used to find upline address.
     *
     * @param account - wallet of new user
     * @param level - number of level bought (0 - 63)
     *
     */
    function findUpline(address account, uint256 level) internal view returns(address) {
        address ref = users[account].referral;
        if (_uplines[account][level] != address(0)) {
            return _uplines[account][level];
        } else if (_isActive[ref][level] || users[ref].isLeader) {
            return ref;
        } else {
            return address(0);
        }
    }

    /**
     * @dev Internal function used to process payment to uplines.
     *
     * Emits an {UplineFound} and {Payment} events.
     *
     * @param account - wallet of payee
     * @param level - number of level bought (0 - 63)
     *
     */
    function processPayment(address account, uint256 level) internal {
        uint256 totalAmount = _prices[level];
        uint256 toPool = totalAmount * _poolFee / 100;
        uint256 rest = totalAmount - toPool;
        _poolAmount += toPool;
        emit BonusAdded(toPool);
        bool sent;
        for (uint i = 0; i < 3; i++) {
            account = findUpline(account, level);
            emit UplineFound(account, i);
            if (account == address(0)) {
                break;
            } else {
                if (i == 0) {
                    (sent, ) = payable(account).call{value: totalAmount * 40 / 100}("");
                    require(sent, "Failed to send BNB");
                    emit Payment(account, "level 1", totalAmount * 40 / 100);
                    rest -= (totalAmount * 40 / 100);
                    users[account].earned += totalAmount * 40 / 100;
                    if (users[account].isLeader) {
                        break;
                    }
                } else if (i==1) {
                    (sent, ) = payable(account).call{value: totalAmount * 20 / 100}("");
                    require(sent, "Failed to send BNB");
                    emit Payment(account, "level 2", totalAmount * 20 / 100);
                    rest -= (totalAmount * 20 / 100);
                    users[account].earned += totalAmount * 20 / 100;
                    if (users[account].isLeader) {
                        break;
                    }
                } else {
                    (sent, ) = payable(account).call{value: totalAmount * 10 / 100}("");
                    require(sent, "Failed to send BNB");
                    rest -= (totalAmount * 10 / 100);
                    emit Payment(account, "level 3", totalAmount * 10 / 100);
                    users[account].earned += totalAmount * 10 / 100;
                }
            }

        }
        (sent, ) = payable(_developerWallet).call{value: rest * _developerFee / 100}("");
        require(sent, "Failed to send BNB");
        emit Payment(_developerWallet, "developer", rest * _developerFee / 100);
        rest -= (rest * _developerFee / 100);
        (sent, ) = payable(_platformWallet[0]).call{value: rest / 2}("");
        require(sent, "Failed to send BNB");
        emit Payment(_platformWallet[0], "platform_1", rest / 2);
        (sent, ) = payable(_platformWallet[1]).call{value: rest - rest / 2}("");
        require(sent, "Failed to send BNB");
        emit Payment(_platformWallet[1], "platform_2", rest - rest / 2);
    }

    /**
     * @dev Buy appropriate level by the caller.
     *
     * @param _level - number of level to buy (0 - 63)
     *
     * Requirements:
     *
     * - caller must be registered.
     * - 'level' must be within 0-63
     * - 'level' reveal date must be less than current time
     * - caller should't have this level bought before
     * - msg.value must be grater or equal to price of level
     * - caller must not have a Leader status
     *
     */
    function buyLevel(uint256 _level) public payable {
        require((_level >= 0 && _level < 64), "Invalid level");
        require(block.timestamp >= _revealDates[_level], "This level is not yet available");
        require(!_isActive[_msgSender()][_level], "You have already bought this level");
        require(msg.value >= _prices[_level], "Insufficient BNB to buy level");
        require(users[_msgSender()].id > 0, "User is not registered");
        require(!users[_msgSender()].isLeader, "Leader's levels are being opened automatically");
        _isActive[_msgSender()][_level] = true;
        address upline = findFreePlace(_msgSender(), _level);
        if (upline != address(0)) {
            _matrix[upline][_level].push(_msgSender());
            _uplines[_msgSender()][_level] = upline;
        }

        processPayment(_msgSender(), _level);

        if (!users[_msgSender()].isActive && !users[_msgSender()].isLeader) {
            users[_msgSender()].isActive = true;
            _activeUsers += 1;
        }

        if (msg.value > _prices[_level]) {
            uint256 change = msg.value - _prices[_level];
            (bool sent, ) = payable(_msgSender()).call{value: change}("");
            require(sent, "Failed to send BNB");
        }

    }

    /**
     * @dev View the available bonus for 'account'.
     *
     * @param
     * - 'account' - wallet of user
     *
     */
    function getAvailableBonus(address account) public view returns(uint256) {
        if (!users[account].isActive && !users[account].isLeader) return 0;
        return _poolAmount / (_activeUsers + _leaders.length) - users[account].claimed;
    }


    /**
     * @dev Claim of poll reward by the caller.
     *
     * Emits an {RewardClaimed} event.
     *
     * Requirements:
     *
     * - caller must be registered.
     * - available reward for caller must be grater that zero
     *
     */
    function claimReward() external nonReentrant {
        require(users[_msgSender()].id > 0, "User not registered");
        if (!users[_msgSender()].isLeader) {
            require(users[_msgSender()].isActive, "Unauthorized request");
        }
        uint256 reward = _poolAmount / (_activeUsers + _leaders.length) - users[_msgSender()].claimed;
        require(reward > 0, "No reward to claim for this account");
        users[_msgSender()].claimed += reward;
        (bool sent, ) = payable(_msgSender()).call{value: reward}("");
        require(sent, "Failed to send BNB");
        emit RewardClaimed(_msgSender(), reward);
    }


    function recoverBNB(uint256 _amount) external onlyOwner {
        uint256 balance = address(this).balance;
        require(balance >= _amount, "Insufficient contract balance");
        (bool sent, ) = payable(owner()).call{value: _amount, gas: 100000}("");
        require(sent, "Failed to send BNB payment to owner");
    }


}