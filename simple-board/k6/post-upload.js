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
    console.log(res.body);
  }
}


const titleAndContents = [
  {
    title: "미드 vs 정글 블루 버프 양보 싸움",
    content:
      "정글러가 첫 블루 버프 나한테 주는 게 맞는 거 아니냐? 내가 마나 부족해서 라인전 힘들다는데 왜 안 주냐고!",
  },
  {
    title: "탑 vs 정글 갱킹 타이밍 관련 싸움",
    content:
      "탑 라이너가 적 정글 위치 파악도 안 하고 무작정 갱 오라는데, 이게 맞냐? 내가 적 정글러한테 죽었는데?",
  },
  {
    title: "서폿 vs 정글 드래곤 싸움",
    content:
      "서포터가 와드도 안 해놓고 드래곤 치자고 하는데, 정글러로서 어이가 없네. 와드부터 해줘야 내가 드래곤 칠 거 아니냐?",
  },
  {
    title: "탑 vs 미드 로밍 싸움",
    content:
      "탑 라이너가 계속 로밍 와서 미드 킬 다 먹는데, 이게 맞냐? 미드 라인 방치해도 되냐고!",
  },
  {
    title: "정글 vs 원딜 레드 버프 싸움",
    content:
      "정글러가 2차 레드 버프도 자기 먹겠다고 하는데, 원딜한테 줘야 되는 거 아니냐? 후반에 내가 캐리하려면 필요하다고!",
  },
  {
    title: "미드 vs 원딜 블루 버프 관련 싸움",
    content:
      "미드 라이너가 블루 버프를 원딜한테 양보하라는데, 내가 마나 필요해서 힘든데 원딜이 가져가는 게 맞냐?",
  },
  {
    title: "정글 vs 서폿 시야 장악 싸움",
    content:
      "정글러가 시야 잡으라고 서폿한테 짜증내는데, 서폿이 와드 충분히 박았는데 왜 그러는 거임? 정글도 시야 봐야 되는 거 아님?",
  },
  {
    title: "탑 vs 정글 CS 먹기 싸움",
    content:
      "탑 라이너가 자꾸 정글 CS 먹어서 정글링 힘들다는데, 탑 밀리면 게임 지는 거 아닌가?",
  },
  {
    title: "정글 vs 미드 킬 양보 싸움",
    content:
      "정글러가 미드 킬 다 먹어서 내가 크지 못하는데, 정글이 킬을 나눠줘야 맞는 거 아니냐?",
  },
  {
    title: "원딜 vs 서폿 포지션 싸움",
    content:
      "원딜이 서포터한테 너무 앞으로 나가서 죽지 말라고 하는데, 라인전 압박하려면 어느 정도 나가야 되는 거 아님?",
  },
  {
    title: "서폿 vs 원딜 서렌 콜 싸움",
    content:
      "서포터가 자꾸 서렌 치자고 하는데, 원딜로서 게임 더 해보고 싶은데 서렌 콜이 맞는 거임?",
  },
  {
    title: "미드 vs 탑 텔레포트 싸움",
    content:
      "미드 라이너가 탑 텔레포트 아끼지 말고 쓰라는데, 내가 언제 써야 할지 몰라서 아낀 거 맞음?",
  },
  {
    title: "정글 vs 탑 초반 갱킹 싸움",
    content:
      "탑 라이너가 초반에 갱킹 오라고 짜증내는데, 정글로서 초반에 다른 라인도 봐야 하는 거 아님?",
  },
  {
    title: "원딜 vs 미드 포탑 밀기 싸움",
    content:
      "원딜이 자꾸 미드 포탑 밀러 오라고 하는데, 미드에서 포탑 밀면 이득인가? 내가 원딜이라서 헷갈리네.",
  },
  {
    title: "서폿 vs 정글 바론 시야 싸움",
    content:
      "정글러가 바론 시야 확보 안 된 상태에서 치자고 해서 서폿으로서 불안한데, 이게 맞는 전략임?",
  },
  {
    title: "미드 vs 정글 카운터 정글 싸움",
    content:
      "미드 라이너가 자꾸 적 정글 카운터 치자고 하는데, 내가 정글로서 위험한 거 아닌가? 같이 가줘야 되는 거 아닌가?",
  },
  {
    title: "정글 vs 원딜 한타 위치 싸움",
    content:
      "정글러가 자꾸 한타에서 원딜 위치 제대로 잡으라고 하는데, 내가 딜 넣기 편한 위치 찾기 어려운데 어떻게 해야 돼?",
  },
  {
    title: "탑 vs 미드 로밍 시기 싸움",
    content:
      "탑 라이너가 언제 로밍 와야 하는지 미드 라이너랑 싸우는데, 탑이 언제 로밍 오는 게 맞아?",
  },
  {
    title: "서폿 vs 원딜 아이템 빌드 싸움",
    content:
      "서폿이 원딜한테 아이템 빌드 이렇게 가라고 지적하는데, 내가 원딜이라 아이템 빌드 헷갈리는데 어떻게 해야 돼?",
  },
  {
    title: "정글 vs 미드 시야 확보 싸움",
    content:
      "정글러가 미드한테 시야 좀 잡으라고 하는데, 미드가 라인 클리어에 집중해서 시야 보기가 어렵다는데 어떻게 해야 맞는 거임?",
  },
  {
    title: "원딜 vs 서폿 킬 스틸 싸움",
    content:
      "서포터가 자꾸 킬 스틸한다고 원딜이 짜증내는데, 서폿이 킬 먹으면 진짜 안 좋은 거임?",
  },
  {
    title: "탑 vs 정글 블루 버프 싸움",
    content:
      "탑 라이너가 자꾸 블루 버프 자기도 달라고 하는데, 정글러로서 블루 버프 주는 게 맞냐?",
  },
  {
    title: "미드 vs 서폿 로밍 지원 싸움",
    content:
      "미드 라이너가 서포터 보고 로밍 오라고 하는데, 서포터로서 언제 로밍 가는 게 맞는 거임?",
  },
  {
    title: "정글 vs 탑 포탑 방어 싸움",
    content:
      "탑 라이너가 정글러 보고 탑 포탑 방어 좀 해달라고 하는데, 내가 다른 라인도 봐야 해서 어려운데 이게 맞냐?",
  },
  {
    title: "원딜 vs 미드 오브젝트 싸움",
    content:
      "미드 라이너가 오브젝트 치자고 하는데, 원딜로서 지금 타이밍에 치는 게 맞는지 모르겠어.",
  },
  {
    title: "서폿 vs 정글 갱킹 지원 싸움",
    content:
      "정글러가 서포터한테 갱킹 올 때 지원 좀 해달라고 하는데, 서폿이 언제 지원해야 맞는 건지 헷갈리네.",
  },
  {
    title: "탑 vs 미드 텔레포트 지원 싸움",
    content:
      "미드 라이너가 탑 텔레포트 아끼지 말고 써달라는데, 탑으로서 언제 써야 할지 모르겠어.",
  },
  {
    title: "정글 vs 원딜 드래곤 타이밍 싸움",
    content:
      "원딜이 정글러한테 드래곤 치자고 하는데, 정글러로서 지금 타이밍에 치는 게 맞는지 모르겠어.",
  },
  {
    title: "미드 vs 서폿 로밍 시기 싸움",
    content:
      "미드 라이너가 서포터한테 언제 로밍 오냐고 짜증내는데, 서폿이 언제 로밍 가야 맞는 건지 헷갈리네.",
  },
  {
    title: "정글 vs 탑 한타 지원 싸움",
    content:
      "탑 라이너가 정글러한테 한타 지원 좀 해달라고 하는데, 내가 다른 라인도 봐야 해서 헷갈리네. 한타 언제 지원해야 맞냐?",
  },
];
