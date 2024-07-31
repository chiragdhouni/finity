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
exports.returnItem = exports.getItemsByLocation = exports.lendItem = exports.requestToBorrowItem = exports.addItem = void 0;
const item_1 = __importDefault(require("../models/item"));
const user_1 = __importDefault(require("../models/user"));
// Adding an item to be listed for lending
const addItem = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { name, description, category, ownerId, location } = req.body;
    try {
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
                location: owner.location
            },
            status: 'available',
            location
        });
        yield item.save();
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
    const { itemId, borrowerId, dueDate } = req.body;
    try {
        const item = yield item_1.default.findById(itemId);
        if (!item) {
            return res.status(404).send('Item not found');
        }
        if (item.status !== 'available') {
            return res.status(400).send('Item is not available for borrowing');
        }
        const borrower = yield user_1.default.findById(borrowerId);
        if (!borrower) {
            return res.status(404).send('Borrower not found');
        }
        res.status(200).send({
            message: 'Borrow request submitted',
            item,
            borrower,
            proposedDueDate: dueDate
        });
    }
    catch (error) {
        console.error(`Error requesting to borrow item: ${error.message}`);
        res.status(400).send(error);
    }
});
exports.requestToBorrowItem = requestToBorrowItem;
// Confirm the lending of an item
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
            location: borrower.location
        };
        yield item.save();
        const owner = yield user_1.default.findById(item.owner.id);
        if (owner) {
            owner.itemsLended.push(itemId);
            yield owner.save();
        }
        borrower.itemsBorrowed.push(itemId);
        yield borrower.save();
        res.status(200).send(item);
    }
    catch (error) {
        console.error(`Error lending item: ${error.message}`);
        res.status(400).send(error);
    }
});
exports.lendItem = lendItem;
// Get items by location
const getItemsByLocation = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { location } = req.query;
    try {
        const items = yield item_1.default.find({ location });
        res.status(200).send(items);
    }
    catch (error) {
        console.error(`Error fetching items: ${error.message}`);
        res.status(400).send(error);
    }
});
exports.getItemsByLocation = getItemsByLocation;
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
        // Reset item fields
        item.status = 'available';
        item.dueDate = undefined;
        item.borrower = undefined;
        yield item.save();
        // Remove item from borrower's itemsBorrowed list
        borrower.itemsBorrowed = borrower.itemsBorrowed.filter((borrowedItemId) => borrowedItemId !== itemId);
        yield borrower.save();
        // Remove item from owner's itemsLended list
        const owner = yield user_1.default.findById(item.owner.id);
        if (owner) {
            owner.itemsLended = owner.itemsLended.filter((lendedItemId) => lendedItemId !== itemId);
            yield owner.save();
        }
        res.status(200).send(item);
    }
    catch (error) {
        console.error(`Error returning item: ${error.message}`);
        res.status(400).send(error);
    }
});
exports.returnItem = returnItem;
