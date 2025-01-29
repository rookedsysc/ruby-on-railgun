import http from "k6/http";
import { check, sleep } from "k6";

export const options = {
  insecureSkipTLSVerify: true, // 인증서 무시
  vus: 1000,                    // 500명의 가상 사용자
  duration: "5m",              // 5분간 지속
};


export default function () {
  const apiUrl = "http://localhost:8080/api/v1/posts";
  const params = {
    headers: {
      "Content-Type": "application/json"
    },
  };

  // titleAndContents에서 랜덤한 항목 선택
  const selectedContent = titleAndContents[Math.floor(Math.random() * titleAndContents.length)];

  const payload = JSON.stringify({
    title: selectedContent.title,
    content: selectedContent.content
  });

  const res = http.post(apiUrl, payload, params);
  check(res, {
    "status is 200": (r) => r.status === 200,
  });

  if (res.status !== 200 && res.status !== 201) {
    console.log(res.status);
  }
}


const titleAndContents = [
  {
    title: "미드 vs 정글 블루 버프 양보 싸움",
    content:
      "정글러가 첫 블루 버프 나한테 주는 게 맞는 거 아니냐? 내가 마나 부족해서 라인전 힘들다는데 왜 안 주냐고 씨발",
  },
];
