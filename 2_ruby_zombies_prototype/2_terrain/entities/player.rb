class Player
  attr_accessor :x, :y, :angle, :world_x, :world_y

  def initialize(world_x, world_y)
    @sprites = Gosu::TexturePacker.load_json($window, Utils.media_path('sprites.json'), :precise)
    @idle = @sprites.frame('manBlue_stand.png')

    @angle = 0
    @speed = 5

    @x = $window.width / 2
    @y = $window.height / 2
    @world_x = world_x
    @world_y = world_y
  end

  def set_map(map)
    @map = map
  end

  def update
    @angle = Utils.get_angle(@x, @y)
    new_x, new_y = @world_x, @world_y

    # forward
    if $window.button_down?(Gosu::KbW)
      new_x -= @speed * Math.sin(Utils.transform_degrees_to_radians(@angle - 90))
      new_y += @speed * Math.cos(Utils.transform_degrees_to_radians(@angle - 90))
    end

    # backward
    if $window.button_down?(Gosu::KbS)
      new_x -= @speed * Math.sin(Utils.transform_degrees_to_radians(@angle + 90))
      new_y += @speed * Math.cos(Utils.transform_degrees_to_radians(@angle + 90))
    end

    # strafe left
    if $window.button_down?(Gosu::KbA)
      new_x += @speed * Math.sin(Utils.transform_degrees_to_radians(@angle))
      new_y -= @speed * Math.cos(Utils.transform_degrees_to_radians(@angle))
    end    

    # strafe right
    if $window.button_down?(Gosu::KbD)
      new_x -= @speed * Math.sin(Utils.transform_degrees_to_radians(@angle))
      new_y += @speed * Math.cos(Utils.transform_degrees_to_radians(@angle))
    end

    @world_x, @world_y = new_x, new_y unless @map.out_of_bounds?(new_x, new_y)
  end

  def draw
    @idle.draw_rot(@x, @y, 1, @angle)
  end

  def viewport
    [(@world_x - $window.width/2), (@world_y - $window.height/2)]
  end

  def draw_crosshair
    x = $window.mouse_x
    y = $window.mouse_y
    $window.draw_line(
      x - 10, y, Gosu::Color::RED,
      x + 10, y, Gosu::Color::RED, 100)
    $window.draw_line(
      x, y - 10, Gosu::Color::RED,
      x, y + 10, Gosu::Color::RED, 100)
  end
end