# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Rails::RakeEnvironment do
  subject(:cop) { described_class.new(config) }

  let(:config) { RuboCop::Config.new }

  it 'registers an offense to task without :environment' do
    expect_offense(<<~RUBY)
      task :foo do
      ^^^^^^^^^ Include `:environment` task as a dependency for all Rake tasks.
      end
    RUBY
  end

  it 'does not register an offense to task with :environment ' \
     'but it has other dependency before it' do
    expect_no_offenses(<<~RUBY)
      task foo: [:bar, `:environment`] do
      end
    RUBY
  end

  it 'does not register an offense to task with an dependency' do
    expect_no_offenses(<<~RUBY)
      task foo: :bar do
      end
    RUBY
  end

  it 'does not register an offense to task with dependencies' do
    expect_no_offenses(<<~RUBY)
      task foo: [:foo, :bar] do
      end
    RUBY
  end

  it 'does not register an offense to task with a dependency ' \
     'as a method call' do
    expect_no_offenses(<<~RUBY)
      task foo: [:bar, dep]
    RUBY
  end

  it 'does not register an offense to task with :environment' do
    expect_no_offenses(<<~RUBY)
      task foo: `:environment` do
      end
    RUBY
  end

  it 'does not register an offense to task with :environment ' \
     'and other dependencies' do
    expect_no_offenses(<<~RUBY)
      task foo: [`:environment`, :bar] do
      end
    RUBY
  end

  it 'does not register an offense to task with :environment and an argument' do
    expect_no_offenses(<<~RUBY)
      task :foo, [:arg] => `:environment` do
      end
    RUBY
  end

  it 'does not register an offense to task with a dependency ' \
     'as a method call' do
    expect_no_offenses(<<~RUBY)
      task foo: dep
    RUBY
  end

  it 'does not register an offense to task with dependencies ' \
     'as a method call' do
    expect_no_offenses(<<~RUBY)
      task foo: [dep, :bar]
    RUBY
  end

  it 'does not register an offense to the default task' do
    expect_no_offenses(<<~RUBY)
      task default: :spec
    RUBY
  end

  it 'does not register an offense to task with no block' do
    expect_no_offenses(<<~RUBY)
      task(:foo).do_something
    RUBY
  end
end
