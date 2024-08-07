import mongoose, { Schema, Document, Types } from 'mongoose';

interface ILostItem extends Document {

    name: string;
    description: string;
    category: string;
    status: string;
    owner: {
        id: string; // Use ObjectId instead of string
        name: string;
        email: string;
        address: string;
    };
    location: {
        type: string;
        coordinates: [number, number];
      };
}