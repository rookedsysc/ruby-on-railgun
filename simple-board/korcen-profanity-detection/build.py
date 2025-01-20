import h5py
import tensorflow as tf
from tensorflow.keras import layers, models

# 저장된 모델 파일 경로
model_path = "app/models/vdcnn_model_with_kogpt2.h5"

# HDF5 파일 열기
with h5py.File(model_path, "r") as f:
    print("Layers in saved model:")
    for layer in f["model_weights"].keys():
        print(f"Layer: {layer}")
    
    print("\nShapes of weights:")
    for layer_name, layer_group in f["model_weights"].items():
        if isinstance(layer_group, h5py.Group):  # Group 내 데이터셋 탐색
            print(f"Layer: {layer_name}")
            for weight_name, weight_value in layer_group.items():
                print(f"  {weight_name}: {weight_value.shape}")

# 모델 생성 및 가중치 로드
model = build_model()
model.load_weights("app/models/vdcnn_model_with_kogpt2.h5")

# 모델 요약 출력
model.summary()

model = build_model()  # 저장된 구조와 동일한 모델 정의
model.load_weights("app/models/vdcnn_model_with_kogpt2.h5")  # 가중치만 로드

# 모델 정의
model = build_model()

# 학습된 가중치 로드 (원래 학습 모델이 있는 경우)
# model.fit(...) 수행 후 가중치를 저장
model.save("app/models/vdcnn_model_with_kogpt2.h5")
