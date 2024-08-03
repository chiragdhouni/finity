import mongoose, { Schema, Document, Types } from 'mongoose';

interface IUser extends Document {
  name: string;
  email: string;
  password: string;
  address: string;
  itemsListed: Types.ObjectId[];
  itemsLended: Types.ObjectId[];
  itemsBorrowed: Types.ObjectId[];
  itemsRequested: Types.ObjectId[];
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

  // Use ObjectId type for item references
  itemsListed: { type: [mongoose.Schema.Types.ObjectId], ref: 'Item', default: [] },
  itemsLended: { type: [mongoose.Schema.Types.ObjectId], ref: 'Item', default: [] },
  itemsBorrowed: { type: [mongoose.Schema.Types.ObjectId], ref: 'Item', default: [] },
  itemsRequested: { type: [mongoose.Schema.Types.ObjectId], ref: 'Item', default: [] },

  location: {
    type: { type: String, enum: ['Point'], default: 'Point' }, // Default to 'Point' for a valid GeoJSON
    coordinates: {
      type: [],
      default: [0.0,0.0], // Default to an empty array
    },
  },
});

// Create a 2dsphere index for geospatial queries if location is provided
UserSchema.index({ location: '2dsphere' });

export default mongoose.model<IUser>('User', UserSchema);
