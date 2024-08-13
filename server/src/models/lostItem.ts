import mongoose, { Schema, Document, Types } from 'mongoose';

interface ILostItem extends Document {
    name: string;
    description: string;
    // category: string;
    status: string;
    dateLost: Date;
    contactInfo:string
    claims: Types.ObjectId[];
    owner: {
        id: Types.ObjectId;
        name: string;
        email: string;
        address: string;
    };
    location: {
        type: string;
        coordinates: [number, number];
    };

}

const LostItemSchema: Schema = new Schema({
    name: { type: String, required: true },
    description: { type: String, required: true },
    // category: { type: String, required: true },
    status: { type: String, required: true, enum: ['lost', 'found'] },
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
});

LostItemSchema.index({ location: '2dsphere' });

export default mongoose.model<ILostItem>('LostItem', LostItemSchema);