# LLM Parallel Evaluation Framework

A comprehensive framework for orchestrating multiple Large Language Model (LLM) calls in parallel and combining their results through systematic evaluation and ranking. This project demonstrates advanced patterns for agent parallelization and "LLM-as-a-Judge" evaluation methodology.

## 🎯 Project Overview

This project implements a sophisticated workflow that:

1. **Generates Dynamic Questions**: Uses an LLM to create challenging, nuanced questions
2. **Parallel Model Orchestration**: Simultaneously queries multiple LLM providers (OpenAI, Anthropic, AWS Bedrock, Google Gemini, xAI, Ollama)
3. **Automated Evaluation**: Employs multiple judge models to rank and score responses
4. **Statistical Aggregation**: Calculates average rankings across all judges for objective results

## 🏗️ Architecture

### Core Components

- **Multi-Provider Client Management**: Unified interface for different LLM providers
- **Parallel Execution Engine**: ThreadPoolExecutor-based concurrent processing
- **Response Parsing & Validation**: Robust JSON extraction with error handling
- **Ranking & Aggregation System**: Statistical analysis of judge evaluations

### Workflow Pipeline

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Question      │    │   Parallel      │    │   Evaluation    │
│   Generation    ├────►   Model Calls   ├────►   & Ranking     │
│                 │    │                 │    │                 │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         ▼                       ▼                       ▼
  Single LLM Call         ThreadPoolExecutor      Judge Models
  Question Creation       6+ Models Queried       Statistical Analysis
```

## 🚀 Quick Start

### Prerequisites

- Python 3.9+
- Virtual environment (recommended)
- API keys for desired LLM providers

### Installation

1. **Clone and setup environment:**
```bash
git clone <repository-url>
cd llm_evaluation
make setup
```

2. **Configure environment variables:**
Create a `.env` file in the project root:
```env
# Required for AWS Bedrock
AWS_BEARER_TOKEN_BEDROCK=your_bedrock_token

# Optional - include as needed
OPENAI_API_KEY=your_openai_key
ANTHROPIC_API_KEY=your_anthropic_key
GEMINI_API_KEY=your_google_key
XAI_API_KEY=your_xai_key
```

3. **Install dependencies:**
```bash
# Production dependencies
pip install -r requirements.txt

# Development dependencies (includes testing, linting)
pip install -r requirements-dev.txt
```

### Running the Application

```bash
# Run the main evaluation script
python src/llm_parallel_evaluation_with\ _errorhandling.py
```

## 📋 Supported LLM Providers

| Provider | API Interface | Models Supported | Notes |
|----------|---------------|------------------|-------|
| **AWS Bedrock** | Native Bedrock | Nova, Llama3-3, etc. | Requires AWS credentials |
| **Anthropic** | Native | Claude 3.5/Sonnet, etc. | Direct API integration |
| **OpenAI** | Native | GPT-4, GPT-3.5, etc. | Standard OpenAI API |
| **Google Gemini** | OpenAI-compatible | Gemini 2.5 Flash/Pro | Via OpenAI wrapper |
| **xAI** | OpenAI-compatible | Grok models | Via OpenAI wrapper |
| **Ollama** | OpenAI-compatible | Local models | Requires local Ollama server |

## ⚙️ Configuration

### Model Configuration

Edit the model dictionaries in `main()` to customize which models participate:

```python
# Competitor models (answer questions)
models = {
    "bedrock": "us.meta.llama3-3-70b-instruct-v1:0",
    "anthropic": "claude-3-7-sonnet-latest",
    "openai": "gpt-5-mini",
    "google": "gemini-2.5-flash",
    "xai": "grok-3-mini",
    "ollama": "gpt-oss:20b"
}

# Judge models (evaluate responses)
judging_models = {
    "bedrock": "us.amazon.nova-pro-v1:0",
    "anthropic": "claude-sonnet-4-20250514",
    "openai": "o3-mini",
    "google": "gemini-2.5-pro"
}
```

### Error Handling

The framework includes comprehensive error handling:

- **Client Initialization**: Graceful degradation if providers are unavailable
- **API Call Failures**: Individual model failures don't stop the pipeline
- **JSON Parsing**: Robust extraction handles various response formats
- **Ranking Calculation**: Handles incomplete evaluations

## 🔧 Development

### Code Quality

The project uses modern Python development practices:

```bash
# Format code
make format

# Run linting
make lint

# Run tests
make test

# Type checking
mypy src/
```

### Project Structure

```
llm_evaluation/
├── src/
│   └── llm_parallel_evaluation_with _errorhandling.py  # Main application
├── tests/                                              # Test files
├── requirements.txt                                    # Production dependencies
├── requirements-dev.txt                               # Development dependencies
├── pyproject.toml                                     # Tool configuration
├── Makefile                                           # Development commands
└── README.md                                          # This file
```

## 📊 Output & Results

The framework provides detailed output including:

1. **Progress Tracking**: Real-time status of each model call
2. **Response Aggregation**: Compiled answers from all participants
3. **Evaluation Results**: Judge rankings and reasoning
4. **Final Rankings**: Statistical average rankings with confidence scores

Example output:
```
🏆 Rank: 1 -- Model: claude-3-7-sonnet-latest    Average rank: 1.25 🏆
🏆 Rank: 2 -- Model: gpt-5-mini                  Average rank: 2.50 🏆
🏆 Rank: 3 -- Model: gemini-2.5-flash           Average rank: 3.75 🏆
```

## 🔍 Key Features

### Parallel Processing
- **ThreadPoolExecutor**: Concurrent API calls for improved performance
- **Future Management**: Robust handling of asynchronous operations
- **Resource Management**: Automatic cleanup and error recovery

### Provider Abstraction
- **Unified Interface**: Consistent API across different providers
- **Type Safety**: Full type annotations with mypy compliance
- **Client Management**: Automatic initialization and configuration

### Evaluation System
- **Multiple Judges**: Reduces bias through diverse evaluation perspectives
- **Statistical Aggregation**: Average rankings provide objective scoring
- **JSON Parsing**: Handles various response formats and edge cases

## ⚠️ Important Notes

### Token Usage
This framework can consume significant API tokens due to:
- Multiple model calls per evaluation
- Large context windows for judge evaluations
- No built-in rate limiting

**Recommendation**: Start with a small subset of models for testing.

### Provider Dependencies
- **Ollama**: Requires local installation and model availability
- **AWS Bedrock**: Needs proper IAM permissions and region configuration
- **API Keys**: Ensure all keys have sufficient quotas and permissions

## 🤝 Contributing

1. Follow the existing code style (Black, isort)
2. Add type annotations for all functions
3. Include comprehensive error handling
4. Write tests for new functionality
5. Update documentation as needed

## 📚 Use Cases

This framework is ideal for:

- **Model Comparison**: Systematic evaluation of different LLMs
- **Benchmark Creation**: Automated generation of evaluation datasets
- **Research**: Studying LLM behavior and performance patterns
- **Quality Assurance**: Validating model outputs across providers
- **A/B Testing**: Comparing model performance on specific tasks

## 🔮 Future Enhancements

Potential improvements:
- **Async/Await Implementation**: Replace ThreadPoolExecutor with asyncio
- **Configuration Files**: YAML/JSON configuration instead of hardcoded values
- **Database Integration**: Persist results for historical analysis
- **Web Interface**: Interactive dashboard for real-time monitoring
- **Rate Limiting**: Built-in API quota management
- **Custom Metrics**: Pluggable evaluation criteria beyond rankings

---

**Built with**: Python 3.9+, ThreadPoolExecutor, Multiple LLM Provider APIs

For questions, issues, or contributions, please refer to the project's issue tracker.