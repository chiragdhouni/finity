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
const UserSchema = new mongoose_1.Schema({
    name: { type: String, required: true },
    email: { type: String, required: true },
    password: { type: String, required: true }, // Password field
    address: { type: String, required: true },
    // Use ObjectId type for item references
    itemsListed: { type: [mongoose_1.default.Schema.Types.ObjectId], ref: 'Item', default: [] },
    itemsLended: { type: [mongoose_1.default.Schema.Types.ObjectId], ref: 'Item', default: [] },
    itemsBorrowed: { type: [mongoose_1.default.Schema.Types.ObjectId], ref: 'Item', default: [] },
    itemsRequested: { type: [mongoose_1.default.Schema.Types.ObjectId], ref: 'Item', default: [] },
    location: {
        type: { type: String, enum: ['Point'], default: 'Point' }, // Default to 'Point' for a valid GeoJSON
        coordinates: {
            type: [Number],
            default: [0.0, 0.0], // Default to an empty array
        },
    },
});
// Create a 2dsphere index for geospatial queries if location is provided
UserSchema.index({ location: '2dsphere' });
exports.default = mongoose_1.default.model('User', UserSchema);
