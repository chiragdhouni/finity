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
    id: Types.ObjectId; // Use ObjectId instead of string
    name: string;
    email: string;
    address: IAddress;
  };
  borrower: {
    id: Types.ObjectId; // Use ObjectId instead of string
    name: string;
    email: string;
    address: IAddress;
  } | null;
  dueDate: Date | null;
  location: {
    type: string;
    coordinates: [number, number];
  };
  address : IAddress;
  
}

const ItemSchema: Schema = new Schema({
  name: { type: String, required: true },
  description: { type: String, required: true },
  category: { type: String, required: true },
  status: { type: String, required: true, enum: ['available', 'lended', 'borrowed'] },
  owner: {
    id: { type: mongoose.Schema.Types.ObjectId, required: true }, // ObjectId type
    name: { type: String, required: true },
    email: { type: String, required: true },
    address: AddressSchema
  },
  borrower: {
    id: { type: mongoose.Schema.Types.ObjectId, default: null }, // ObjectId type
    name: { type: String, default: null },
    email: { type: String, default: null },
    address: AddressSchema
  },
  dueDate: { type: Date, default: null },
  location: {
    type: { type: String, enum: ['Point'], required: true },
    coordinates: { type: [Number], required: true },
  },
  address: AddressSchema,
});

// Create a 2dsphere index for geospatial queries
ItemSchema.index({ location: '2dsphere' });

export default mongoose.model<IItem>('Item', ItemSchema);
