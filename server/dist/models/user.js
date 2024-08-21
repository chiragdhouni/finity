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
// Assume `io` is your Socket.IO server instance
let io;
const NotificationSchema = new mongoose_1.Schema({
    userId: { type: mongoose_1.default.Schema.Types.ObjectId, required: true },
    itemId: { type: mongoose_1.default.Schema.Types.ObjectId },
    type: { type: String, required: true },
    message: { type: String, required: true },
    read: { type: Boolean, default: false },
    createdAt: { type: Date, default: Date.now }, // Add this line
});
const UserSchema = new mongoose_1.Schema({
    name: { type: String, required: true },
    email: { type: String, required: true },
    password: { type: String, required: true },
    address: { type: String, required: true },
    events: { type: [mongoose_1.default.Schema.Types.ObjectId], ref: 'Event', default: [] },
    itemsListed: { type: [mongoose_1.default.Schema.Types.ObjectId], ref: 'Item', default: [] },
    itemsLended: { type: [mongoose_1.default.Schema.Types.ObjectId], ref: 'Item', default: [] },
    itemsBorrowed: { type: [mongoose_1.default.Schema.Types.ObjectId], ref: 'Item', default: [] },
    itemsRequested: { type: [mongoose_1.default.Schema.Types.ObjectId], ref: 'Item', default: [] },
    notifications: [NotificationSchema], // Embedded schema
    location: {
        type: { type: String, enum: ['Point'], default: 'Point' },
        coordinates: {
            type: [Number],
            default: [0.0, 0.0],
        },
    },
});
// Create a 2dsphere index for geospatial queries if location is provided
UserSchema.index({ location: '2dsphere' });
// UserSchema.post('save', function (doc) {
//   // Emit a Socket.IO event when the user document is updated
//   if (io) {
//     io.to(`user_${doc._id}`).emit('user_update', doc);
//   }
// });
// UserSchema.post('findOneAndUpdate', function (doc) {
//   // Emit a Socket.IO event when the user document is updated via findOneAndUpdate
//   if (io && doc) {
//     io.to(`user_${doc._id}`).emit('user_update', doc);
//   }
// });
// // Initialize your Socket.IO instance
// export const initializeSocket = (socketIO: Server) => {
//   io = socketIO;
// };
exports.default = mongoose_1.default.model('User', UserSchema);
