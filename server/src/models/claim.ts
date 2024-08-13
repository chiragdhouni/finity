import mongoose, { Schema, Document, Types } from 'mongoose';

interface IClaim extends Document {
    userId: Types.ObjectId;
    lostItemId: Types.ObjectId;
    proofText: string;
    proofImages: string[]; // URLs of uploaded images
    status: string; // pending, accepted, rejected
    createdAt: Date;
}

const ClaimSchema: Schema = new Schema({
    userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    lostItemId: { type: mongoose.Schema.Types.ObjectId, ref: 'LostItem', required: true },
    proofText: { type: String, required: true },
    proofImages: [{ type: String }], // Array of image URLs
    status: { type: String, enum: ['pending', 'accepted', 'rejected'], default: 'pending' },
    createdAt: { type: Date, default: Date.now },
});

export const Claim = mongoose.model<IClaim>('Claim', ClaimSchema);