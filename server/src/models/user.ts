import mongoose, { Schema, Document } from 'mongoose';

interface IUser extends Document {
  name: string;
  email: string;
  password: string;
  location: string;
  itemsLended: string[];
  itemsBorrowed: string[];
  itemsRequested: string[];
}

const UserSchema: Schema = new Schema({

  name: { type: String, required: true },
  email: { type: String, required: true },
  password: { type: String, required: true },  // Password field
  location: { type: String, required: true },
  itemsLended: { type: [String], default: [] },
  itemsBorrowed: { type: [String], default: [] },
  itemsRequested: { type: [String], default: [] },
});

export default mongoose.model<IUser>('User', UserSchema);
