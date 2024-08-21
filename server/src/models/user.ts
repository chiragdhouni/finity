import mongoose, { Schema, Document, Types } from 'mongoose';
import { Server } from 'socket.io';

// Assume `io` is your Socket.IO server instance
let io: Server;

interface IUser extends Document {
  name: string;
  email: string;
  password: string;
  address: string;
  events: Types.ObjectId[];
  itemsListed: Types.ObjectId[];
  itemsLended: Types.ObjectId[];
  itemsBorrowed: Types.ObjectId[];
  itemsRequested: Types.ObjectId[];
  notifications: Types.ObjectId[];
  location?: {
    type: string;
    coordinates: [number, number];
  };
}

const UserSchema: Schema<IUser> = new Schema({
  name: { type: String, required: true },
  email: { type: String, required: true },
  password: { type: String, required: true },
  address: { type: String, required: true },
  events: { type: [mongoose.Schema.Types.ObjectId], ref: 'Event', default: [] },
  itemsListed: { type: [mongoose.Schema.Types.ObjectId], ref: 'Item', default: [] },
  itemsLended: { type: [mongoose.Schema.Types.ObjectId], ref: 'Item', default: [] },
  itemsBorrowed: { type: [mongoose.Schema.Types.ObjectId], ref: 'Item', default: [] },
  itemsRequested: { type: [mongoose.Schema.Types.ObjectId], ref: 'Item', default: [] },
  notifications: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Notification' }],
  location: {
    type: { type: String, enum: ['Point'], default: 'Point' },
    coordinates: {
      type: [Number],
      default: [0.0, 0.0],
    },
  },
});
declare global {
  namespace Express {
    interface Request {
      user?: IUser & Document; // Adjust based on your IUser interface
      token?: string;
    }
  }
}

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

export default mongoose.model<IUser>('User', UserSchema);
