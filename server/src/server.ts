import express from 'express';
import mongoose from 'mongoose';
import bodyParser from 'body-parser'; // Import the bodyParser module
import authRoutes from './routes/authRoutes';
import itemRoutes from './routes/itemRoutes';
import eventRoutes from './routes/eventRoutes';


const app = express();
app.use(express.json());
app.use(bodyParser.json());
// const PORT = process.env.PORT || 3000;
const MONGO_URI:string = 'mongodb+srv://chirag:chirag@cluster0.dgdbyqm.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0';

mongoose.connect(MONGO_URI)
  .then(() => console.log('MongoDB connected'))
  .catch(err => console.log(err));


app.use('/api/auth', authRoutes);
app.use('/api/items', itemRoutes);
app.use('/api/events', eventRoutes);
app.get('/', (req, res) => {
    res.send('Hello World');
  });

app.listen(3001, () => {
    console.log(`Server is running on port ${3001}`);
  });

  