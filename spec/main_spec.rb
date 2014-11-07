describe "Application 'FogBurner'" do
  before do
    @app = NSApplication.sharedApplication
  end

  it "has a status menu" do
    @app.delegate.statusMenu.nil?.should == false
  end

  it "has six menu items" do
    @app.delegate.statusMenu.itemArray.length.should == 6
  end
end
