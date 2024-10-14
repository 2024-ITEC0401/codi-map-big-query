CREATE OR REPLACE TABLE `bqml_codi_map.codi_map_summary_test` AS (
  WITH parsed_data AS (
    SELECT
      uri,
      ARRAY_TO_STRING(
        SPLIT(
          REGEXP_EXTRACT(uri, r'/([^/]+)\.jpg$'),
          '-'
        ), ', '
      ) AS hashtags,
      CONCAT(
        '''
        아래의 스키마를 보고 이미지를 분석해서 json데이터를 생성해.
        해쉬태그를 참고해서 이미지를 분석하고 해쉬태그를 그대로 json에 포함시켜.
        type Color =
    | "흰색"
    | "크림"
    | "베이지"
    | "연회색"
    | "진회색"
    | "검정"
    | "연분홍"
    | "노랑"
    | "연두"
    | "민트"
    | "하늘색"
    | "연보라"
    | "분홍"
    | "코랄"
    | "주황"
    | "초록"
    | "파랑"
    | "보라"
    | "빨강"
    | "카멜"
    | "갈색"
    | "카키"
    | "네이비"
    | "와인"
    | "골드"
    | "실버";

const CategoryMap = {
    상의: ["반소매 티셔츠", "긴팔 티셔츠", "민소매", "카라티", "탱크탑", "크롭탑", "블라우스", "긴팔셔츠", "반팔셔츠", "맨투맨", "후드", "니트", "니트조끼", "스포츠상의", "바디수트"],
    원피스: ["캐주얼 원피스", "티셔츠 원피스", "셔츠 원피스", "후드 원피스", "니트 원피스", "자켓 원피스", "멜빵 원피스", "점프수트", "이브닝 원피스", "미니 원피스"],
    바지: ["청바지", "긴바지", "정장바지", "운동복", "레깅스", "반바지"],
    치마: ["미니스커트", "미디스커트", "롱스커트"],
    아우터: [
        "코트",
        "트렌치",
        "털코트",
        "무스탕",
        "블레이저",
        "자켓",
        "블루종",
        "야구잠바",
        "트러커",
        "라이더자켓",
        "가디건",
        "집업",
        "야상",
        "스포츠아우터",
        "후리스",
        "파카",
        "경량패딩",
        "패딩",
        "조끼",
    ],
    신발: ["스니커즈", "슬립온", "운동화", "등산화", "부츠", "워커", "어그부츠", "로퍼", "보트", "플랫슈즈", "힐", "샌들", "샌들힐", "슬리퍼", "뮬힐"],
    가방: ["토트백", "숄더백", "크로스백", "웨이스트백", "에코백", "백팩", "보스턴백", "클러치백", "서류가방", "짐색", "캐리어"],
    모자: ["캡", "햇", "비니", "베레모", "페도라", "썬햇"],
};

type valueof<T> = T[keyof T];

type Category = {
    category: keyof typeof CategoryMap;
    subCategory: valueof<keyof typeof CategoryMap>;
};

interface Clothes {
    category: Category;
    baseColor: Color;
    pointColor: Color;
    season: "봄" | "여름" | "가을" | "겨울";
    styles: "데일리" | "직장" | "데이트" | "경조사" | "여행" | "홈웨어" | "파티" | "운동" | "특별한날" | "학교" | "기타";
    textile: "면" | "린넨" | "폴리에스테르" | "니트/울" | "퍼" | "트위드" | "나일론" | "데님" | "가죽" | "스웨이드" | "벨벳" | "쉬폰" | "실크" | "코듀로이" | "메탈릭" | "레이스" | "기타";
    pattern: "무지" | "체크" | "스트라이프" | "프린트" | "도트" | "애니멀" | "플로럴" | "트로피칼" | "페이즐리" | "아가일" | "밀리터리" | "컬러블럭" | "반복" | "기타";
}

interface Codi {
    name: string;
    clothes: Clothes[];
    hashtags: string[];
} analyze image and generate text based on these hashtags: ''', ARRAY_TO_STRING(
          SPLIT(
            REGEXP_EXTRACT(uri, r'/([^/]+)\.jpg$'),
            '-'
          ), ', '
      )) AS prompt
    FROM
      `bqml_codi_map.codi`
  )

  SELECT
    uri,
    ml_generate_text_llm_result
  FROM
    ML.GENERATE_TEXT(
      MODEL `bqml_codi_map.gemini-flash`,
      TABLE parsed_data,
      STRUCT(
        0.2 AS temperature,
        TRUE AS FLATTEN_JSON_OUTPUT,
        2048 AS max_output_tokens
      )
    )
);
