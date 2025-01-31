import http from "k6/http";
import { check, sleep } from "k6";

export const options = {
  insecureSkipTLSVerify: true, // 인증서 무시
  vus: 500,                    // 500명의 가상 사용자
  duration: "1m",              // 5분간 지속
};

export default function () {
  const apiUrl = "http://localhost:8081/api/v1/trigram/grpc?query=어제 먹은 콘푸라이트가 너무 맛있어서 오늘도 먹고 싶어서 또 먹었어. 다른것도 먹어야 하는데 왜 자꾸 이거만 먹고 싶을까?? 골고루 먹어야 건강해진다고 했는뎅 짱 맛있당 히히히. 근데 내일도 먹고 시이이이이이이발 먹고 싶으면 싶으면 어떡하지?";
  const params = {
    headers: {
      "accept": "*/*",
      "Content-Type": "application/json"
    },
  };

  const res = http.get(apiUrl, params);
  check(res, {
    "status is 200": (r) => r.status === 200,
  });

  if (res.status !== 200 && res.status !== 201) {
    console.log(res.status);
  }
}