import tensorflow as tf

model_path = "app/models/vdcnn_model_with_kogpt2.h5"

try:
    model = tf.keras.models.load_model(model_path)
    print("Loaded full model:")
    model.summary()  # 전체 모델 구조 출력
except Exception as e:
    print(f"Failed to load full model: {e}")

try:
    model = tf.keras.Sequential()  # 빈 Sequential 모델 생성
    model.load_weights(model_path)
    print("Loaded weights successfully.")
except Exception as e:
    print(f"Failed to load weights: {e}")
