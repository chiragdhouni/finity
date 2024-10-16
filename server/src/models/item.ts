import mongoose, { Schema, Document, Types } from 'mongoose';

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

interface IItem extends Document {
  name: string;
  description: string;
  category: string;
  status: string;
  owner: {
    id: Types.ObjectId;
    name: string;
    email: string;
    address: IAddress;
  };
  borrower: {
    id: Types.ObjectId;
    name: string;
    email: string;
    address: IAddress;
  } | null;
  dueDate: Date | null;
  location: {
    type: string;
    coordinates: [number, number];
  };
}

const ItemSchema: Schema = new Schema({
  name: { type: String, required: true },
  description: { type: String, required: true },
  category: { type: String, required: true },
  status: { type: String, required: true, enum: ['available', 'lended', 'borrowed'] },
  owner: {
    id: { type: mongoose.Schema.Types.ObjectId, required: true },
    name: { type: String, required: true },
    email: { type: String, required: true },
    address: AddressSchema,
  },
  borrower: {
    id: { type: mongoose.Schema.Types.ObjectId, default: null },
    name: { type: String, default: null },
    email: { type: String, default: null },
    address: { type: AddressSchema, default: null },
  },
  dueDate: { type: Date, default: null },
  location: {
    type: { type: String, enum: ['Point'], required: true },
    coordinates: { type: [Number], required: true },
  },
});

// Create a 2dsphere index for geospatial queries
ItemSchema.index({ location: '2dsphere' });

export default mongoose.model<IItem>('Item', ItemSchema);
