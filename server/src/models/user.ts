import mongoose, { Schema, Document, Types } from 'mongoose';
import { Server } from 'socket.io';

// Assume `io` is your Socket.IO server instance
let io: Server;

interface IAddress {
  address?: string;
  city?: string;
  state?: string;
  country?: string;
  zipCode?: string;
}

const AddressSchema: Schema = new Schema({
    address: { type: String },
    city: { type: String },
    state: { type: String },
    country: { type: String },
    zipCode: { type: String },
  });


interface IUser extends Document {
  name: string;
  email: string;
  password: string;
  profilePicture?: string;
  address: IAddress;
  events: Types.ObjectId[];
  itemsListed: Types.ObjectId[];
  itemsLended: Types.ObjectId[];
  itemsBorrowed: Types.ObjectId[];
  itemsRequested: Types.ObjectId[];
  notifications: INotification[]; // Changed this line
  location?: {
    type: string;
    coordinates: [number, number];
  };
}

interface INotification {
  userId: mongoose.Types.ObjectId; // from whom the notification is
  itemId?: mongoose.Types.ObjectId; // item related to the notification
  type: string;
  message: string;

  read: boolean;
  createdAt: Date;
  
}

const NotificationSchema: Schema<INotification> = new Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, required: true },
  itemId: { type: mongoose.Schema.Types.ObjectId },
  type: { type: String, required: true },
  message: { type: String, required: true },
  read: { type: Boolean, default: false },
  createdAt: { type: Date, default: Date.now }, // Add this line
}, 
);



const UserSchema: Schema<IUser> = new Schema({
  name: { type: String, required: true },
  email: { type: String, required: true },
  password: { type: String, required: true },
  profilePicture: { type: String },
  address: AddressSchema,
  events: { type: [mongoose.Schema.Types.ObjectId], ref: 'Event', default: [] },
  itemsListed: { type: [mongoose.Schema.Types.ObjectId], ref: 'Item', default: [] },
  itemsLended: { type: [mongoose.Schema.Types.ObjectId], ref: 'Item', default: [] },
  itemsBorrowed: { type: [mongoose.Schema.Types.ObjectId], ref: 'Item', default: [] },
  itemsRequested: { type: [mongoose.Schema.Types.ObjectId], ref: 'Item', default: [] },
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

declare global {
  namespace Express {
    interface Request {
      user?: IUser & Document; // Adjust based on your IUser interface
      token?: string;
    }
  }
}

UserSchema.post('save', function (doc) {
  if (io) {
    io.to(`${doc._id}_room`).emit('user_update', doc);
    console.log(`User ${doc._id} has been updated. from save`);
  }
});

UserSchema.post('findOneAndUpdate', function (doc) {
  if (io && doc) {
    io.to(`${doc._id}_room`).emit(`user_update_${doc._id}`, doc);
    console.log(`User ${doc._id} has been updated. from findOneAndUpdate`);
  }
});
// Initialize your Socket.IO instance
export const initializeSocket = (socketIO: Server) => {
  io = socketIO;
};

export default mongoose.model<IUser>('User', UserSchema);
