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
  
  
    interface IEvent extends Document {
        title: string;
        image: string[]; // Updated to an array of strings
        description: string;
        owner: {
            id: Types.ObjectId;
            name: string;
            email: string;
            address: IAddress;
        };
        date: Date;
        address: IAddress;
        location: {
            type: string;
            coordinates: [number, number];
        };
    }
    
    const EventSchema: Schema = new Schema({
        title: { type: String, required: true },
        image: { type: [String], required: true }, // Updated to an array of strings
        description: { type: String, required: true },
        owner: {
            id: { type: mongoose.Schema.Types.ObjectId, required: true },
            name: { type: String, required: true },
            email: { type: String, required: true },
            address: AddressSchema
        },
        date: { type: Date, required: true },
        address: AddressSchema,
        location: {
            type: { type: String, enum: ['Point'], required: true },
            coordinates: { type: [Number], required: true },
        },
    });
    
// Create a geospatial index on the location field
EventSchema.index({ location: '2dsphere' });

export default mongoose.model<IEvent>('Event', EventSchema);
