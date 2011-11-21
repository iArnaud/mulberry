require 'spec_helper'
require 'mulberry/code_creator'

describe Mulberry::CodeCreator do
  before :each do
    @source_dir = 'testapp'
    Mulberry::App.scaffold(@source_dir, true)
  end

  after :each do
    FileUtils.rm_rf @source_dir
  end

  it "should raise an error if trying to create a file that already exists" do
    lambda {
      Mulberry::CodeCreator.new('component', @source_dir, 'fake')
      Mulberry::CodeCreator.new('component', @source_dir, 'fake')
    }.should raise_error
  end

  it "should raise an error if asked to create an unknown code type" do
    lambda {
      Mulberry::CodeCreator.new('unknown', @source_dir, 'fake')
    }.should raise_error
  end

  describe "component creation" do
    before :each do
      Mulberry::CodeCreator.new('component', @source_dir, 'FooBarBaz')
    end

    it "should create the component file" do
      c = File.join(@source_dir, 'javascript', 'components', 'FooBarBaz.js')
      File.exists?(c).should be_true
      File.read(c).should match 'client.components.FooBarBaz'
    end

    it "should create the component resources directory" do
      d = File.join(@source_dir, 'javascript', 'components', 'FooBarBaz')
      File.exists?(d).should be_true
      File.directory?(d).should be_true
    end

    it "should create the component template" do
      t = File.join(@source_dir, 'javascript', 'components', 'FooBarBaz', 'FooBarBaz.haml')
      File.exists?(t).should be_true
      File.read(t).should match '.component.foo-bar-baz'
    end

    it "should require the component in the base.js" do
      js = File.join(@source_dir, 'javascript', 'base.js')
      File.read(js).should == "dojo.require('client.components.FooBarBaz');\n"
    end

    it "should create the component styles" do
      s = File.join(@source_dir, 'javascript', 'components', 'FooBarBaz', '_foo-bar-baz.scss')
      File.exists?(s).should be_true
      File.read(s).should match '.component.foo-bar-baz \{'
    end

    it "should import the component style in the base.scss" do
      scss = File.join(@source_dir, 'themes', 'default', 'base.scss')
      File.read(scss).should match '@import \'../../javascript/components/FooBarBaz/foo-bar-baz\';'
    end
  end

  describe "capability creation" do
    before :each do
      Mulberry::CodeCreator.new('capability', @source_dir, 'BizBopBim')
    end

    it "should create the capability file" do
      c = File.join(@source_dir, 'javascript', 'capabilities', 'BizBopBim.js')
      File.exists?(c).should be_true
      File.read(c).should match 'client.capabilities.BizBopBim'
    end

    it "should require the capability in the base.js" do
      js = File.join(@source_dir, 'javascript', 'base.js')
      File.read(js).should == "dojo.require('client.capabilities.BizBopBim');\n"
    end
  end
end
