# Oil Industry ERP Structure Study

Date: 2026-03-15

## Purpose

정유 산업의 생산 및 물류 구조를 ERP 관점에서 어떻게 모델링할 수 있는지 탐색

---

## 1. 정유 산업 기본 구조

정유 산업은 하나의 원유(Crude Oil)에서 여러 제품이 동시에 생산되는 **연산품(Joint Production)** 구조를 가진다.

또한 생산은 **연속 공정(Continuous Process)** 기반으로 진행된다.

대표적인 정제 제품

- LPG
- Gasoline
- Diesel
- Jet Fuel
- Bunker C Oil
- Asphalt

원유 품질은 다음 기준에 따라 달라진다.

- API Gravity
- Sulfur 함량

일반적으로

- 경질유(light crude) → 휘발유, 항공유 등 생산
- 중질유(heavy crude) → Bunker C 등 생산

---

## 2. 원유 물류 및 운송 구조

원유 운송 방식

- 유조선 (수입 / 수출)
- 파이프라인 (내수)
- 유조차

프로젝트에서는 다음과 같은 흐름을 가정할 수 있음

Crude Procurement

→ Tank Storage

→ Refining Process

→ Product Storage

→ Distribution

---

## 3. 정유 생산 공정 (프로젝트 단순 모델)

실제 정유 공정은 매우 복잡하지만 프로젝트에서는 다음과 같이 단순화 가능

1. 전처리 (Pre-treatment)
2. 정제 공정 (Distillation / Refining)
3. 후처리 (Secondary Processing)

또한 공정 전 단계에서 **Blending 과정**이 존재할 수 있음

예시

Crude A + Crude B

→ Blend Feed (API 조정)

---

## 4. 정유 산업 재고 관리 특징

정유 산업에서는 재고 관리가 **Tank 단위**로 이루어지는 경우가 많다.

ERP 관점 모델

Plant

→ Storage Location

→ Tank (Batch)

즉

**Tank = Batch 단위 관리**

이유

- 석유 제품은 혼유 방지가 매우 중요
- 동일 제품이라도 Tank 단위로 품질 관리 필요

예

Gasoline Batch A → Tank 1

Gasoline Batch B → Tank 2

---

## 5. 생산 구조 (PP 관점)

정유 산업은 일반 제조업 PP가 아닌

**PP-PI (Process Industry)** 기반 생산 구조를 사용한다.

특징

- Continuous production
- Recipe 기반 생산
- Joint production (co-product)

또한 공정 산업에서는

**PP/DS (Production Planning / Detailed Scheduling)** 적용 가능

---

## 6. MM 관점 특징

일반 제조업과 달리 정유 산업에서는

- 원유 대량 구매
- Tank 단위 재고 관리
- Batch 기반 품질 관리

가 중요하다.

ERP에서는 다음 구조로 관리 가능

Material

→ Tank

→ Batch

---

## 7. ERP 전체 흐름 (초안)

Crude Procurement (MM)

↓

Tank Farm (Inventory)

↓

Refining Process (PP-PI)

↓

Product Tank

↓

Sales (SD)

↓

Logistics Execution (LE)

↓

Finance / Controlling (FI / CO)

---

## Notes

정유 산업 특징

- 연속 공정 기반 생산
- 연산품 생산 구조
- Tank 기반 재고 관리

따라서 ERP 설계 시

- PP-PI
- Batch Management
- Tank Inventory

구조를 고려해야 한다.
