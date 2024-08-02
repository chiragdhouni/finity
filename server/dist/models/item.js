"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (k !== "default" && Object.prototype.hasOwnProperty.call(mod, k)) __createBinding(result, mod, k);
    __setModuleDefault(result, mod);
    return result;
};
Object.defineProperty(exports, "__esModule", { value: true });
const mongoose_1 = __importStar(require("mongoose"));
const ItemSchema = new mongoose_1.Schema({
    name: { type: String, required: true },
    description: { type: String, required: true },
    category: { type: String, required: true },
    status: { type: String, required: true, enum: ['available', 'lended', 'borrowed'] },
    owner: {
        id: { type: mongoose_1.default.Schema.Types.ObjectId, required: true }, // ObjectId type
        name: { type: String, required: true },
        email: { type: String, required: true },
        address: { type: String, required: true }
    },
    borrower: {
        id: { type: mongoose_1.default.Schema.Types.ObjectId, default: null }, // ObjectId type
        name: { type: String, default: null },
        email: { type: String, default: null },
        address: { type: String, default: null }
    },
    dueDate: { type: Date, default: null },
    location: {
        type: { type: String, enum: ['Point'], required: true },
        coordinates: { type: [Number], required: true },
    },
});
// Create a 2dsphere index for geospatial queries
ItemSchema.index({ location: '2dsphere' });
exports.default = mongoose_1.default.model('Item', ItemSchema);
