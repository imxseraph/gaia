import React, { Component } from 'react';
import logo from './logo.svg';
import './App.css';

class App extends Component {
  render() {
    return (
      <div className="App">
        <header className="App-header">
          <img src={logo} className="App-logo" alt="logo" />
          <h1 className="App-title">欢迎来到轻语树洞，在这里可以与其他人分享你内心的秘密。</h1>
          <h3>你所留下的话，不带有任何可追踪的特征，本站负责为你保管这个秘密7天，期间可以被他人看到，随后彻底消失。</h3>
        </header>
      </div>
    );
  }
}

export default App;
