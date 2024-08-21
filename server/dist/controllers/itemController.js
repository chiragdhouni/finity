"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.searchItems = exports.returnItem = exports.getNearbyItems = exports.lendItem = exports.requestToBorrowItem = exports.addItem = void 0;
const item_1 = __importDefault(require("../models/item"));
const user_1 = __importDefault(require("../models/user"));
const notification_1 = require("../models/notification");
// Adding an item to be listed for lending
const addItem = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { name, description, category, ownerId, dueDate } = req.body;
    try {
        if (!name || !description || !category || !ownerId) {
            return res.status(400).send('Missing required fields');
        }
        const owner = yield user_1.default.findById(ownerId);
        if (!owner) {
            return res.status(404).send('Owner not found');
        }
        const item = new item_1.default({
            name,
            description,
            category,
            owner: {
                id: owner._id,
                name: owner.name,
                email: owner.email,
                address: owner.address
            },
            status: 'available',
            location: owner.location,
            dueDate: dueDate ? new Date(dueDate) : null, // Parse and set the due date if provided
        });
        yield item.save();
        owner.itemsListed.push(item._id);
        yield owner.save();
        res.status(201).send(item);
    }
    catch (error) {
        console.error(`Error adding item: ${error.message}`);
        res.status(400).send(error);
    }
});
exports.addItem = addItem;
// Request to borrow an item
const requestToBorrowItem = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { itemId, borrowerId } = req.body;
    try {
        // Find the item by ID
        const item = yield item_1.default.findById(itemId);
        if (!item) {
            return res.status(404).send('Item not found');
        }
        // Check if the item is available for borrowing
        if (item.status !== 'available') {
            return res.status(400).send('Item is not available for borrowing');
        }
        // Find the borrower by ID
        const borrower = yield user_1.default.findById(borrowerId);
        if (!borrower) {
            return res.status(404).send('Borrower not found');
        }
        // Add the item to the borrower's requested items
        borrower.itemsRequested.push(itemId);
        yield borrower.save();
        // Find the owner of the item
        const owner = yield user_1.default.findById(item.owner.id);
        const notification = new notification_1.Notification({
            type: 'borrowRequest',
            userId: borrower._id,
            message: `Someone has requested to borrow your item: ${item.name}.`
        });
        yield notification.save();
        owner === null || owner === void 0 ? void 0 : owner.notifications.push(notification._id);
        owner === null || owner === void 0 ? void 0 : owner.save();
        // Send success response
        res.status(200).send({
            message: 'Borrow request submitted',
            item,
            borrower,
        });
    }
    catch (error) {
        console.error(`Error requesting to borrow item: ${error.message}`);
        res.status(500).send('Internal server error');
    }
});
exports.requestToBorrowItem = requestToBorrowItem;
const lendItem = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { itemId, borrowerId, dueDate } = req.body;
    try {
        const item = yield item_1.default.findById(itemId);
        if (!item) {
            return res.status(404).send('Item not found');
        }
        if (item.status !== 'available') {
            return res.status(400).send('Item is not available for lending');
        }
        const borrower = yield user_1.default.findById(borrowerId);
        if (!borrower) {
            return res.status(404).send('Borrower not found');
        }
        item.status = 'lended';
        item.dueDate = dueDate;
        item.borrower = {
            id: borrower._id,
            name: borrower.name,
            email: borrower.email,
            address: borrower.address,
        };
        yield item.save();
        const owner = yield user_1.default.findById(item.owner.id);
        if (owner) {
            owner.itemsLended.push(itemId);
            yield owner.save();
        }
        borrower.itemsBorrowed.push(itemId);
        borrower.itemsRequested = borrower.itemsRequested.filter((requestedItemId) => requestedItemId !== itemId);
        yield borrower.save();
        res.status(200).send(item);
    }
    catch (error) {
        console.error(`Error lending item: ${error.message}`);
        res.status(400).send(error);
    }
});
exports.lendItem = lendItem;
const getNearbyItems = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { latitude, longitude, maxDistance } = req.query;
    try {
        const items = yield item_1.default.aggregate([
            {
                $geoNear: {
                    near: {
                        type: 'Point',
                        coordinates: [parseFloat(longitude), parseFloat(latitude)],
                    },
                    distanceField: 'dist.calculated',
                    maxDistance: parseFloat(maxDistance), // Maximum distance in meters
                    spherical: true,
                },
            },
            {
                $project: {
                    name: 1,
                    description: 1,
                    category: 1,
                    status: 1,
                    owner: 1,
                    borrower: 1,
                    dueDate: 1,
                    location: 1,
                    address: 1,
                    // distance: '$dist.calculated',
                },
            },
        ]);
        res.status(200).json(items);
    }
    catch (error) {
        res.status(500).json({ error: error.message });
    }
});
exports.getNearbyItems = getNearbyItems;
// Return an item
const returnItem = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    var _a;
    const { itemId } = req.body;
    try {
        const item = yield item_1.default.findById(itemId);
        if (!item) {
            return res.status(404).send('Item not found');
        }
        if (item.status !== 'lended') {
            return res.status(400).send('Item is not currently lended');
        }
        const borrower = yield user_1.default.findById((_a = item.borrower) === null || _a === void 0 ? void 0 : _a.id);
        if (!borrower) {
            return res.status(404).send('Borrower not found');
        }
        // Remove item from borrower's itemsBorrowed list
        borrower.itemsBorrowed = borrower.itemsBorrowed.filter((borrowedItemId) => borrowedItemId !== itemId);
        yield borrower.save();
        // Remove item from owner's itemsLended list
        const owner = yield user_1.default.findById(item.owner.id);
        if (owner) {
            owner.itemsLended = owner.itemsLended.filter((lendedItemId) => lendedItemId !== itemId);
            yield owner.save();
        }
        // Reset item fields
        item.status = 'available';
        item.dueDate = null;
        item.borrower = null;
        yield item.save();
        res.status(200).send(item);
    }
    catch (error) {
        console.error(`Error returning item: ${error.message}`);
        res.status(400).send(error);
    }
});
exports.returnItem = returnItem;
const searchItems = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { query } = req.query;
    try {
        const items = yield item_1.default.find({ name: { $regex: query, $options: 'i' } });
        res.status(200).json(items);
    }
    catch (error) {
        console.error(`Error searching items: ${error.message}`);
        res.status(400).send(error);
    }
});
exports.searchItems = searchItems;
