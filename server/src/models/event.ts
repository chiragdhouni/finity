import mongoose, { Schema, Document, Types } from 'mongoose';

interface IEvent extends Document {
    title: string;
    description: string;
    owner: {
        id: Types.ObjectId;
        name: string;
        email: string;
        address: string;
    };
    date: Date;
    address: string;
    location: {
        type: string;
        coordinates: [number, number];
    };
}

const EventSchema: Schema = new Schema({
    title: { type: String, required: true },
    description: { type: String, required: true },
    owner: {
        id: { type: mongoose.Schema.Types.ObjectId, required: true },
        name: { type: String, required: true },
        email: { type: String, required: true },
        address: { type: String, required: true },
    },
    date: { type: Date, required: true },
    address: { type: String, required: true },
    location: {
        type: { type: String, enum: ['Point'], required: true },
        coordinates: { type: [Number], required: true },
    },
});

// Create a geospatial index on the location field
EventSchema.index({ location: '2dsphere' });

export default mongoose.model<IEvent>('Event', EventSchema);
