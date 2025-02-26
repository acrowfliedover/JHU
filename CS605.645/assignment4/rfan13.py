import streamlit as st
import numpy as np
import matplotlib.pyplot as plt  # type: ignore
import pandas as pd
from typing import List, Tuple, Dict, Callable, Set
from copy import deepcopy

# sidebar components
# connectivity 3 on a board of size 20 * 20 is a good balance between complexity and realistic 
form_sidebar = st.sidebar.form(key="options")
form_sidebar.header("Grid Size")
width = form_sidebar .number_input("Select a width", value=20, min_value=1, max_value=100, step=1)
height = form_sidebar .number_input("Select a height", value=20, min_value=1, max_value=100, step=1)
connectivity = form_sidebar.slider(
    "Select terrain connectivity:",min_value=0, max_value=10, value=3
)
form_sidebar.write("0 means completely random, and the higher the more connective")
buttonSubmit = form_sidebar.form_submit_button("Generate terrain")

# here below are all the functions that don't interact with streamlit directly

def calculate_values(random_noise, connectivity):
    """
     Create a new matrix such that every cell is the average of all cells within 'connectivity' distance away from the cell in the noise matrix
    """
    values = random_noise
    for i in range(len(values)):
        for j in range(len(values[0])):
            count = 0
            sum = 0
            for k in range(len(random_noise)):
                for l in range(len(random_noise[0])):
                    if abs(k-i)+abs(l-j) <= connectivity:
                        count += 1
                        sum += random_noise[k][l]
            values[i][j] = sum / count
    return values

def create_world(terrain_values):
    """
    3. Assign each cell's terrain by it's percentile in the whole data set:
        from lowest to highest: swamp, plains, forests, hills, mountains
        Here swamp is lower than 15th percentile, plains 50th...and so on
        May adjust if needed, I think the current distribution works well
    """
    world = terrain_values
    all_values = [item for sublist in terrain_values for item in sublist]
    all_values.sort()
    percentile_15 = np.percentile(all_values, 15)
    percentile_50 = np.percentile(all_values, 50)
    percentile_75 = np.percentile(all_values, 75)
    percentile_90 = np.percentile(all_values, 90)
    for i in range(len(world)):
        for j in range(len(world[0])):
            if terrain_values[i][j] < percentile_15:
                world[i][j] = '🐊'
            elif terrain_values[i][j] < percentile_50:
                world[i][j] = '🌾'
            elif terrain_values[i][j] < percentile_75:
                world[i][j] = '🌲'
            elif terrain_values[i][j] < percentile_90:
                world[i][j] = '⛰'
            else:
                world[i][j] = '🌋'
    return world

def generate_terrain(width, height, connectivity):
    """
    Here is the process of generating the terrain:
    1. Generate random noise between 0 and 1 in a height by width matrix
    2. Create a new matrix such that every cell is the average of all cells within 'connectivity' distance away from the cell in the noise matrix
    3. Assign each cell's terrain by it's percentile in the whole data set:
        from lowest to highest: swamp, plains, forests, hills, mountains
    """
    random_noise = [[np.random.uniform(0, 1) for _ in range(width)] for _ in range(height)]

    terrain_values = calculate_values(random_noise, connectivity)

    return create_world(terrain_values)

def display_emoji_grid(emoji_grid):
    """
    Display a List of Lists of emojis in a perfect grid (table) in Streamlit.
    
    Parameters:
    emoji_grid (list of list of str): A 2D list containing emojis to display in a grid.
    """
    # Create HTML table
    html = '<table style="border-collapse: collapse;">'
    
    for row in emoji_grid:
        html += '<tr>'
        for emoji in row:
            html += f'<td style="border: none; padding: 0px; text-align: center; font-size: 1em;">{emoji}</td>'
        html += '</tr>'
    
    html += '</table>'
    
    # Display the HTML table in Streamlit
    st.write(html, unsafe_allow_html=True)

# constants needed below
MOVES = [(0,-1), (1,0), (0,1), (-1,0)]
COSTS = { '🌾': 1, '🌲': 3, '⛰': 5, '🐊': 7}

# all code copied form the week 1 assignment with minor adjustments
def heuristic(current_state: Tuple[int, int], goal_state: Tuple[int, int]) -> int:
    x_distance = abs(current_state[0] - goal_state[0])
    y_distance = abs(current_state[1] - goal_state[1])
    return x_distance + y_distance

def check_valid_move(current_state: Tuple[int, int], move: Tuple[int, int], world: List[List[str]], visited: Set[Tuple[int, int]]) -> bool:
    new_x = current_state[0] + move[0]
    new_y = current_state[1] + move[1]
    if new_x < 0 or new_y < 0 or new_y >= len(world) or new_x >= len(world[0]): # assume the world is a rectangle
        return False
    if world[new_y][new_x] == '🌋':
        return False
    if (new_x, new_y) in visited:
        return False
    return True

def a_star_search( world: List[List[str]], start: Tuple[int, int], goal: Tuple[int, int], costs: Dict[str, int], moves: List[Tuple[int, int]], heuristic: Callable) -> List[Tuple[int, int]]:
    if world[start[1]][start[0]] == '🌋' or world[goal[1]][goal[0]] == '🌋':
        return []
    frontier = [[heuristic(start, goal) + costs[world[start[1]][start[0]]], costs[world[start[1]][start[0]]], [], start]]
    visited = {start}
    while frontier:
        frontier.sort()
        current_state_data = frontier.pop(0)
        current_state = current_state_data[-1]
        for move in moves:
            if check_valid_move(current_state, move, world, visited):
                next_state = (current_state[0] + move[0], current_state[1] + move[1])
                visited.add(next_state)
                next_path =  deepcopy(current_state_data[2])
                next_path.append(move)
                if next_state == goal:
                    return next_path
                next_cost = current_state_data[1] + costs[world[next_state[1]][next_state[0]]]
                frontier.append([heuristic(next_state,goal)+next_cost, next_cost, next_path, next_state])
    return []

def get_move_emoji(move: Tuple[int, int], emojis: List[str]) -> str:
    if move[0] == 1 and move[1] == 0:
        return emojis[0]
    if move[0] == -1 and move[1] == 0:
        return emojis[1]
    if move[0] == 0 and move[1] == -1:
        return emojis[2]
    if move[0] == 0 and move[1] == 1:
        return emojis[3]
    return emojis[0]

def pretty_print_path( world: List[List[str]], path: List[Tuple[int, int]], start: Tuple[int, int], goal: Tuple[int, int], costs: Dict[str, int]) -> int:
    if world[start[1]][start[0]] == '🌋' or world[goal[1]][goal[0]] == '🌋':
        return -1
    st.session_state.path = True
    new_world = deepcopy(world)
    current_state = start
    total_cost = 0
    for move in path:
        total_cost += costs[world[current_state[1]][current_state[0]]]
        emoji = get_move_emoji (move, ['⏩','⏪','⏫','⏬'])
        new_world[current_state[1]][current_state[0]] = emoji
        current_state = (current_state[0] + move[0], current_state[1] + move[1])
    total_cost += costs[world[current_state[1]][current_state[0]]]
    new_world[goal[1]][goal[0]] = '🎁'
    st.session_state.pathed_terrain = new_world
    return total_cost

# initialize dataframe to be displayed 
# also generate new dataframe when submit button is pressed
if "terrain" not in st.session_state or buttonSubmit:
    st.session_state.path = False
    st.session_state.terrain = generate_terrain(width, height, connectivity)
    
# title and header for the page
st.title("Assignment 4")
st.header("A* Search")

# main form to display start and goal
form_main = st.form(key = "main")

# setting the starting and goal points, default to the top left and bottom right corner
starting_x = form_main.number_input("starting point x", value=0, min_value=0, max_value=width-1, step=1)
starting_y = form_main.number_input("starting point y", value=0, min_value=0, max_value=height-1, step=1)
target_x = form_main.number_input("target point x", value=width-1, min_value=0, max_value=width-1, step=1)
target_y = form_main.number_input("target point y", value=height-1, min_value=0, max_value=height-1, step=1)
buttonDisplay = form_main.form_submit_button("Display Path")

# displaying the pathed world when pressed display path
if buttonDisplay:
    path = a_star_search(world=st.session_state.terrain, start = (starting_x, starting_y), goal = (target_x, target_y), costs = COSTS, moves = MOVES, heuristic = heuristic)
    total_cost = pretty_print_path(world=st.session_state.terrain, path = path, start = (starting_x, starting_y), goal = (target_x, target_y), costs = COSTS) 
    if not path and (starting_x != target_x or target_x != target_y):
         st.write("No valid path between start and target")
    else:
         st.write("Total cost is ",total_cost)

# display the board after generation
if "terrain" in st.session_state and not st.session_state.path:
    display_emoji_grid(st.session_state.terrain)
elif "pathed_terrain" in st.session_state and st.session_state.path:
    display_emoji_grid(st.session_state.pathed_terrain)