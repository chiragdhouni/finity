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
  
  
interface ILostItem extends Document {
    name: string;
    description: string;
    image: string[];
    status: string;
    dateLost: Date;
    contactInfo: string;
    claims: Types.ObjectId[];
    owner: {
        id: Types.ObjectId;
        name: string;
        email: string;
        address: IAddress;
    };
    location: {
        type: string;
        coordinates: [number, number];
    };
    foundAt?: Date; // Optional field to track when the item is marked as found
    address : IAddress;
}

const LostItemSchema: Schema = new Schema({
    name: { type: String, required: true },
    description: { type: String, required: true },
    status: { type: String, required: true, enum: ['lost', 'found'] },
    image: { type: [String], required: true }, 
    dateLost: { type: Date, required: true },
    contactInfo: { type: String, required: true },
    claims: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Claim' }],
    owner: {
        id: { type: mongoose.Schema.Types.ObjectId, required: true },
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
    const lostItem = this as unknown as ILostItem;

    if (lostItem.isModified('status') && lostItem.status === 'found') {
        lostItem.foundAt = new Date();
    }

    next();
});

export default mongoose.model<ILostItem>('LostItem', LostItemSchema);
