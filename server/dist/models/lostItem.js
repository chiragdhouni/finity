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
const AddressSchema = new mongoose_1.Schema({
    address: { type: String },
    city: { type: String },
    state: { type: String },
    country: { type: String },
    zipCode: { type: String },
});
const LostItemSchema = new mongoose_1.Schema({
    name: { type: String, required: true },
    description: { type: String, required: true },
    status: { type: String, required: true, enum: ['lost', 'found'] },
    dateLost: { type: Date, required: true },
    contactInfo: { type: String, required: true },
    claims: [{ type: mongoose_1.default.Schema.Types.ObjectId, ref: 'Claim' }],
    owner: {
        id: { type: mongoose_1.default.Schema.Types.ObjectId, required: true },
        name: { type: String, required: true },
        email: { type: String, required: true },
        address: { type: String, required: true }
    },
    location: {
        type: { type: String, enum: ['Point'], required: true },
        coordinates: { type: [Number], required: true },
    },
    foundAt: { type: Date, expires: '2d' }, // TTL index to delete the document 2 days after foundAt
    address: AddressSchema,
});
LostItemSchema.index({ location: '2dsphere' });
// Middleware to set foundAt when status is changed to "found"
LostItemSchema.pre('save', function (next) {
    const lostItem = this;
    if (lostItem.isModified('status') && lostItem.status === 'found') {
        lostItem.foundAt = new Date();
    }
    next();
});
exports.default = mongoose_1.default.model('LostItem', LostItemSchema);
