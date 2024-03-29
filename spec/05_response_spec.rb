require "spec_helper"

RSpec.describe Surveyor::Response do
  subject { described_class.new(email: "hello-world77@me.com", segments: %w[Melbourne Female]) }

  it "has an email address" do
    expect(subject.email).to eq("hello-world77@me.com")
  end

  it "has segments" do
    expect(subject.segments.length).to eq(2)
  end

  it "can be asked for answers" do
    question = Surveyor::FreeTextQuestion.new(title: "Test Question")
    answer = subject.add_answer(question: question, value: "User Answer")
    expect(subject.answers).to eq(answer)
  end

  context "add_answer" do
    free_text_question = Surveyor::FreeTextQuestion.new(title: "Free Text Question")
    rating_question = Surveyor::RatingQuestion.new(title: "Rating Question")

    it "can have answers to FreeTextQuestion added when value is valid String" do
      subject.add_answer(question: free_text_question, value: "User Answer")
      expect(subject.answers[0].value).to eq("User Answer")
    end

    it "does not add an answer to Response when free text question value is not valid" do
      subject.add_answer(question: free_text_question, value: 3)
    rescue ArgumentError
      expect(subject.answers.length).to eq(0)
    end

    it "raises an error when an answer to a free text question is not valid" do
      expect { subject.add_answer(question: free_text_question, value: 3) }.to raise_error(ArgumentError)
    end

    it "can have answers to RatingQuestion added when value is valid Integer" do
      subject.add_answer(question: rating_question, value: 2)
      expect(subject.answers[0].value).to eq(2)
    end

    it "does not add an answer to Response when rating question value is not valid" do
      subject.add_answer(question: rating_question, value: "Invalid Input")
    rescue ArgumentError
      expect(subject.answers.length).to eq(0)
    end

    it "raises an error when an answer to a rating question is not valid" do
      expect { subject.add_answer(question: rating_question, value: "Invalid Input") }.to raise_error(ArgumentError)
    end
  end

  context "segments_contains?" do
    it "can be checked for specific segment values" do
      expect(subject.segments_contains?(segments: %w[Melbourne Female])).to eq(true)
      expect(subject.segments_contains?(segments: %w[Sydney Male])).to eq(false)
      expect(subject.segments_contains?(segments: [])).to eq(true)
    end
  end
end
