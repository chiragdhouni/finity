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
exports.searchLostItem = exports.getNearbyLostItems = exports.deleteLostItem = exports.updateLostItem = exports.getAllLostItems = exports.getLostItemById = exports.createLostItem = void 0;
const lostItem_1 = __importDefault(require("../models/lostItem"));
// Create a new lost item
const createLostItem = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const lostItem = new lostItem_1.default(req.body);
        yield lostItem.save();
        return res.status(201).json(lostItem);
    }
    catch (err) {
        return res.status(400).json({ error: 'Error creating lost item', details: err });
    }
});
exports.createLostItem = createLostItem;
// Get a lost item by ID
const getLostItemById = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const lostItem = yield lostItem_1.default.findById(req.params.id);
        if (!lostItem) {
            return res.status(404).json({ error: 'Lost item not found' });
        }
        return res.status(200).json(lostItem);
    }
    catch (err) {
        return res.status(400).json({ error: 'Error fetching lost item', details: err });
    }
});
exports.getLostItemById = getLostItemById;
// Get all lost items
const getAllLostItems = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const lostItems = yield lostItem_1.default.find();
        return res.status(200).json(lostItems);
    }
    catch (err) {
        return res.status(400).json({ error: 'Error fetching lost items', details: err });
    }
});
exports.getAllLostItems = getAllLostItems;
// Update a lost item by ID
const updateLostItem = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const lostItem = yield lostItem_1.default.findByIdAndUpdate(req.params.id, req.body, { new: true });
        if (!lostItem) {
            return res.status(404).json({ error: 'Lost item not found' });
        }
        return res.status(200).json(lostItem);
    }
    catch (err) {
        return res.status(400).json({ error: 'Error updating lost item', details: err });
    }
});
exports.updateLostItem = updateLostItem;
// Delete a lost item by ID
const deleteLostItem = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const lostItem = yield lostItem_1.default.findByIdAndDelete(req.params.id);
        if (!lostItem) {
            return res.status(404).json({ error: 'Lost item not found' });
        }
        return res.status(200).json({ message: 'Lost item deleted successfully' });
    }
    catch (err) {
        return res.status(400).json({ error: 'Error deleting lost item', details: err });
    }
});
exports.deleteLostItem = deleteLostItem;
// // Search for lost items by location
// export const searchLostItemsByLocation = async (req: Request, res: Response) => {
//     const { longitude, latitude, maxDistance } = req.query;
//     try {
//         const lostItems = await LostItem.find({
//             location: {
//                 $near: {
//                     $geometry: {
//                         type: 'Point',
//                         coordinates: [parseFloat(longitude as string), parseFloat(latitude as string)],
//                     },
//                     $maxDistance: parseInt(maxDistance as string),
//                 },
//             },
//         });
//         return res.status(200).json(lostItems);
//     } catch (err) {
//         return res.status(400).json({ error: 'Error searching lost items by location', details: err });
//     }
// };
// get nearby lost items
const getNearbyLostItems = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { longitude, latitude, maxDistance } = req.query;
    try {
        const lostItems = yield lostItem_1.default.find({
            location: {
                $near: {
                    $geometry: {
                        type: 'Point',
                        coordinates: [parseFloat(longitude), parseFloat(latitude)],
                    },
                    $maxDistance: parseInt(maxDistance),
                },
            },
        });
        return res.status(200).json(lostItems);
    }
    catch (err) {
        return res.status(400).json({ error: 'Error fetching nearby lost items', details: err });
    }
});
exports.getNearbyLostItems = getNearbyLostItems;
//search lost item
const searchLostItem = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { query } = req.query;
    try {
        const lostItems = yield lostItem_1.default.find({
            $or: [
                { title: { $regex: query, $options: 'i' } },
                { description: { $regex: query, $options: 'i' } },
            ],
        });
        return res.status(200).json(lostItems);
    }
    catch (err) {
        return res.status(400).json({ error: 'Error searching lost items', details: err });
    }
});
exports.searchLostItem = searchLostItem;
