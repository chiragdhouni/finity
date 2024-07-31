import mongoose, { Schema, Document } from 'mongoose';

interface IUser {
  id: string;
  name: string;
  email: string;
  location: string;
}

interface IItem extends Document {
  name: string;
  description: string;
  category: string;
  owner: IUser;
  status: string;
  dueDate?: Date | undefined;
  borrower?: IUser;
  location: string;
}

const ItemSchema: Schema = new Schema({
  name: { type: String, required: true },
  description: { type: String, required: true },
  category: { type: String, required: true },
  owner: {
    id: { type: String, required: true },
    name: { type: String, required: true },
    email: { type: String, required: true },
    location: { type: String, required: true }
  },
  status: { type: String, required: true, default: 'available' },
  dueDate: { type: Date },
  borrower: {
    id: { type: String },
    name: { type: String },
    email: { type: String },
    location: { type: String }
  },
  location: { type: String, required: true }
});

export default mongoose.model<IItem>('Item', ItemSchema);
