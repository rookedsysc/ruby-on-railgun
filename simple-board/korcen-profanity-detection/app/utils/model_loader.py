import tensorflow as tf
from tensorflow.keras.preprocessing.sequence import pad_sequences
import pickle

class ModelLoader:
    def __init__(self, tokenizer_path, model_path):
        # Tokenizer 로드
        with open(tokenizer_path, 'rb') as f:
            self.tokenizer = pickle.load(f)

        # 모델 정의
        self.model = self.build_model()

        # 가중치 로드
        self.model.load_weights(model_path)

    def build_model(self):
        return tf.keras.Sequential([
            tf.keras.layers.Conv1D(64, 3, activation="relu", input_shape=(None, 256)),
            tf.keras.layers.GlobalMaxPooling1D(),
            tf.keras.layers.Dense(8, activation="softmax")
        ])

    def predict(self, text):
        tokens = self.tokenizer.texts_to_sequences([text])
        tokens_padded = pad_sequences(tokens, maxlen=256, padding='post')
        prediction = self.model.predict(tokens_padded)
        return prediction[0][0] > 0.5
