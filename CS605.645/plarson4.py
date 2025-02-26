import streamlit as st
import matplotlib.pyplot as plt
import numpy as np
import random
from streamlit import session_state


def populate_randoms(num_rows: int, num_cols: int) -> None:
    '''
    Takes size of table to make and fills all positions with random values.
    Also generates the format required to display the values with two decimal places.
    :param num_rows: the number of rows in the table
    :param num_cols: the number of columns in the table
    :return: None. Updates session_state with table and format.
    '''
    rows = []
    formats = {}
    default_format = st.column_config.NumberColumn(format='%.2f')

    for i in range(num_rows):
        row = []
        for j in range(num_cols):
            row.append(random.uniform(0.0, 1.0))
        rows.append(row)
        formats[i + 1] = default_format

    session_state.table = rows
    session_state.format = formats


if 'table' not in session_state:   # First time running app, create a default table.
    populate_randoms(2, 2)

'''
# Self check
## Edit the Camera View
'''

with st.sidebar:  # Create sidebar elements
    container = st.container(border=True)
    container.subheader('Grid Size')
    num_cols = container.number_input(
        'Select a width:',
        2, 10
    )

    num_rows = container.number_input(
        'Select a height:',
        2, 10
    )

    if container.button("Submit"):
        populate_randoms(num_rows, num_cols)


#  Use data_editor to display table. Update the session state with any changes.
session_state.table = st.data_editor(
    session_state.table,
    hide_index=False,
    column_config=session_state.format
)


#  If the button is clicked, display the Camera View
if st.button('Display'):
    figure = plt.figure(
        figsize=(
            len(session_state.table),
            len(session_state.table[0]))
    )
    axes = figure.add_subplot(1, 1, 1)

    pixels = []
    for row in session_state.table:
        pixel_row = []
        for pixel in row:
            pixel = int((1 - pixel) * 255)
            pixel_row.append(pixel)
        pixels.append(pixel_row)

    axes.set_yticks(range(len(pixels[0])))
    axes.set_title("Camera View")
    axes.imshow(pixels, cmap='gray', vmin=0, vmax=255, origin='lower')
    st.pyplot(figure)

