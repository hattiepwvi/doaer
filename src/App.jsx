import styled from "styled-components";
import Option from "./components/Option.jsx";
import Home from "./components/Home";
import NFT from "./components/NFT";
import ETF from "./components/ETF";

const Container = styled.div`
  height: 100vh;
  scroll-snap-type: y mandatory;
  scroll-behavior: smooth;
  overflow-y: auto;
  scrollbar-width: none;
  color: white; 
  background: url("./img/bg.jpeg");
  &::-webkit-scrollbar{
    display: none;
  }
`;


function App() {

  return (
    <Container>
      <Home />
      <NFT />
      <ETF />
      <Option />
    </Container>
  )  
}

export default App