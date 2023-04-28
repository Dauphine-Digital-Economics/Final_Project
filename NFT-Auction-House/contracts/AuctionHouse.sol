// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./Escrow.sol";
import "./NFT.sol";

contract AuctionHouse  {
    enum ProductStatus {
        Open,
        Sold,
        Unsold
    }
	
    enum ProductCondition {
        New,
        Used
    }

    uint256 public productIndex;
    mapping(address => mapping(uint256 => Product)) stores;
    mapping(uint256 => address) productIdInStore;

    mapping(uint256 => address) productEscrow;

    struct Product {
        uint256 id;
        string name;
        string category;
        string imageLink;
        string descLink;
        uint256 auctionStartTime;
        uint256 auctionEndTime;
        uint256 startPrice;
        address highestBidder;
        uint256 highestBid;
        uint256 secondHighestBid;
        uint256 totalBids;
        ProductStatus status;
        ProductCondition condition;
        mapping(address => mapping(bytes32 => Bid)) bids;
    }

    struct Bid {
        address bidder;
        uint256 productId;
        uint256 value;
        bool revealed;
    }

    event NewProduct(
        uint256 _productId,
        string _name,
        string _category,
        string _imageLink,
        string _descLink,
        uint256 _auctionStartTime,
        uint256 _auctionEndTime,
        uint256 _startPrice,
        uint256 _productCondition
    );

    // constructor() {
    //     productIndex = 0;
    // }
    
    function store(uint256 index_) public {
        productIndex = index_;
    }

    function addProductToStore(
        string memory _name,
        string memory _category,
        string memory _imageLink,
        string memory _descLink,
        uint256 _auctionStartTime,
        uint256 _auctionEndTime,
        string memory _startPrice,
        uint256 _productCondition
    ) public {
        require(_auctionStartTime < _auctionEndTime);
        productIndex += 1;
        Product storage product = stores[msg.sender][productIndex];
        product.id = productIndex;
        product.name = _name;
        product.category = _category;
        product.imageLink = _imageLink;
        product.descLink = _descLink;
        product.auctionStartTime = _auctionStartTime;
        product.auctionEndTime = _auctionEndTime;
        product.startPrice = stringToUint(_startPrice);
        product.status = ProductStatus.Open;
        product.condition = ProductCondition(_productCondition);
        productIdInStore[productIndex] = msg.sender;
		emit NewProduct(productIndex, _name, _category, _imageLink, _descLink, _auctionStartTime, _auctionEndTime, stringToUint(_startPrice), _productCondition);
    }

    function getProduct(uint256 _productId)
        public
        view
        returns (
            uint256,
            string memory,
            string memory,
            string memory,
            string memory,
            uint256,
            uint256,
            uint256,
            ProductStatus,
            ProductCondition
        )
    {
        Product storage product = stores[productIdInStore[_productId]][
            _productId
        ];
        return (
            product.id,
            product.name,
            product.category,
            product.imageLink,
            product.descLink,
            product.auctionStartTime,
            product.auctionEndTime,
            product.startPrice,
            product.status,
            product.condition
        );
    }

    function bid(uint256 _productId, bytes32 _bid)
        public
        payable
        returns (bool)
    {
        Product storage product = stores[productIdInStore[_productId]][
            _productId
        ];
        require(block.timestamp >= product.auctionStartTime, ">");
        require(block.timestamp <= product.auctionEndTime, "<");
        require(msg.value >= product.startPrice, "=");
        require(
            product.bids[msg.sender][_bid].bidder ==
                0x0000000000000000000000000000000000000000,
            "=="
        );
        product.bids[msg.sender][_bid] = Bid(
            msg.sender,
            _productId,
            msg.value,
            false
        );
        product.totalBids += 1;
        return true;
    }

    function revealBid(
        uint256 _productId,
        string memory _amount,
        string memory _secret
    ) public {
        Product storage product = stores[productIdInStore[_productId]][
            _productId
        ];
        require(block.timestamp > product.auctionStartTime);
        bytes32 sealedBid = keccak256(abi.encode(_amount, _secret));
        Bid memory bidInfo = product.bids[msg.sender][sealedBid];
        require(bidInfo.bidder > 0x0000000000000000000000000000000000000000);
        require(bidInfo.revealed == false);
        uint256 refund;
        uint256 amount = stringToUint(_amount);

        uint256 bidInfov = bidInfo.value;
        if (bidInfov < amount) {
            refund = bidInfov;
        } else {
            if (
                address(product.highestBidder) ==
                0x0000000000000000000000000000000000000000
            ) {
                product.highestBidder = msg.sender;
                product.highestBid = amount;
                product.secondHighestBid = product.startPrice;
                refund = bidInfov - amount;
            } else {
                if (amount > product.highestBid) {
                    product.secondHighestBid = product.highestBid;
                    payable(product.highestBidder).transfer(product.highestBid);
                    product.highestBidder = msg.sender;
                    product.highestBid = amount;
                    refund = bidInfov - amount;
                } else if (amount > product.secondHighestBid) {
                    product.secondHighestBid = amount;
                    refund = amount;
                } else {
                    refund = amount;
                }
            }
        }
        product.bids[msg.sender][sealedBid].revealed = true;

        if (refund > 0) {
            payable(msg.sender).transfer(refund);
        }
    }

    function highestBidderInfo(uint256 _productId)
        public
        view
        returns (
            address,
            uint256,
            uint256
        )
    {
        Product storage product = stores[productIdInStore[_productId]][
            _productId
        ];
        return (
            product.highestBidder,
            product.highestBid,
            product.secondHighestBid
        );
    }

    function totalBids(uint256 _productId) public view returns (uint256) {
        Product storage product = stores[productIdInStore[_productId]][
            _productId
        ];
        return product.totalBids;
    }

    function stringToUint(string memory s) private pure returns (uint256) {
        bytes memory b = bytes(s);
        uint256 result = 0;
        for (uint256 i = 0; i < b.length; i++) {
            if (uint8(b[i]) >= 48 && uint8(b[i]) <= 57) {
                result = result * 10 + (uint8(b[i]) - 48);
            }
        }
        return result;
    }

    function finalizeAuction(uint256 _productId) public {
        Product storage product = stores[productIdInStore[_productId]][
            _productId
        ];
        // 48 hours to reveal the bid
        require(block.timestamp > product.auctionEndTime);
        require(product.status == ProductStatus.Open);
        require(product.highestBidder != msg.sender);
        require(productIdInStore[_productId] != msg.sender);

        if (
            product.highestBidder == 0x0000000000000000000000000000000000000000
        ) {
            product.status = ProductStatus.Unsold;
        } else {
            // Whoever finalizes the auction is the arbiter
            Escrow escrow = (new Escrow){value: product.secondHighestBid}(
                _productId,
                product.highestBidder,
                productIdInStore[_productId],
                msg.sender
            );
            productEscrow[_productId] = address(escrow);
            product.status = ProductStatus.Sold;
            // The bidder only pays the amount equivalent to second highest bidder
            // Refund the difference
            uint256 refund = product.highestBid - product.secondHighestBid;
            payable(product.highestBidder).transfer(refund);
        }
    }

    function escrowAddressForProduct(uint256 _productId)
        public
        view
        returns (address)
    {
        return productEscrow[_productId];
    }

    function escrowInfo(uint256 _productId)
        public
        view
        returns (
            address,
            address,
            address,
            bool,
            uint256,
            uint256
        )
    {
        return Escrow(productEscrow[_productId]).escrowInfo();
    }

    function releaseAmountToSeller(uint256 _productId) public {
        Escrow(productEscrow[_productId]).releaseAmountToSeller(msg.sender);
    }

    function refundAmountToBuyer(uint256 _productId) public {
        Escrow(productEscrow[_productId]).refundAmountToBuyer(msg.sender);
    }

    function keccak(string memory _amount, string memory _secret)
        public
        pure
        returns (bytes32)
    {
        bytes32 _bid = keccak256(abi.encode(_amount, _secret));
        return _bid;
    }
}