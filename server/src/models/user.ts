import mongoose, { Schema, Document, Types } from 'mongoose';

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

const UserSchema: Schema = new Schema({
  name: { type: String, required: true },
  email: { type: String, required: true },
  password: { type: String, required: true }, // Password field
  address: { type: String, required: true },

  events: { type: [mongoose.Schema.Types.ObjectId], ref: 'Event', default: [] },
  itemsListed: { type: [mongoose.Schema.Types.ObjectId], ref: 'Item', default: [] },
  itemsLended: { type: [mongoose.Schema.Types.ObjectId], ref: 'Item', default: [] },
  itemsBorrowed: { type: [mongoose.Schema.Types.ObjectId], ref: 'Item', default: [] },
  itemsRequested: { type: [mongoose.Schema.Types.ObjectId], ref: 'Item', default: [] },
  notifications: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Notification' }],
  location: {
    type: { type: String, enum: ['Point'], default: 'Point' }, // Default to 'Point' for a valid GeoJSON
    coordinates: {
      type: [],
      default: [0.0,0.0], // Default to an empty array
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

export default mongoose.model<IUser>('User', UserSchema);
