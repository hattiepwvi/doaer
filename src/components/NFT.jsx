import React from 'react'
import styled from "styled-components"

const Section = styled.div`
  height: 100vh;
  scroll-snap-align: center;
  display: flex;
  justify-content: center;
`;

const Container = styled.div`
  height: 100vh;
  scroll-snap-align: center;
  width: 1400px;
  display: flex;
  justify-content: space-between;
`;

const Left = styled.div`
  flex: 1;
  position: relative;

  @media only screen and (max-width: 768px) {
    display: none;
  }
`;

const Img = styled.img`
  width: 700px;
  height: 600px;
  object-fit: contain;
  position: absolute;
  top: 0;
  bottom: 0;
  left: 0;
  right: 0;
  margin: auto;
  animation: animate 2s infinite ease alternate;

  @media only screen and (max-width: 768px) {
    width: 300px;
    height: 300px;
  }

  @keyframes animate {
    to {
      transform: translateY(20px);
    }
  }
`;



const Title = styled.h1`
  font-size: 74px;

  @media only screen and (max-width: 768px) {
    font-size: 60px;
  }
`;

const Right = styled.div`
  flex: 1;
  display: flex;
  flex-direction: column;
  justify-content: center;
  gap: 20px;

  @media only screen and (max-width: 768px) {
    align-items: center;
    text-align: center;
  }
`;

const WhatWeDo = styled.div`
  display: flex;
  align-items: center;
  gap: 10px;
`;

const Line = styled.img`
  height: 5px;
`;

const Subtitle = styled.h2`
  color: #da4ea2;
`;

const Desc = styled.p`
  font-size: 24px;
  color: lightgray;
`;

const Button = styled.button`
  background-color: #da4ea2;
  color: white;
  font-weight: 500;
  width: 120px;
  padding: 10px;
  border: none;
  border-radius: 5px;
  cursor: pointer;
`;


const NFT = () => {
  return (
    <Section>
      <Container>
        <Left>
          <Img src="./img/air.png" />         
        </Left>
        <Right>
          <Title>Innovative art for everyday use</Title>
          <WhatWeDo>
            <Line src="./img/line.png" />
            <Subtitle>NFT Creation</Subtitle>
          </WhatWeDo>
          <Desc>
          NFT wearables are unique, digital assets that allow users to showcase their ownership of one-of-a-kind virtual items.
          </Desc>
          <Button>See our works</Button>
        </Right>
      </Container>
    </Section>
  );
};
  
  export default NFT
  
