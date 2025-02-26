import streamlit as st
import numpy as np
import matplotlib.pyplot as plt  # type: ignore
import pandas as pd

def generate_list_of_lists(rows, cols):
    """
    Takes a number of rows and cols, generate random uniformly distributed numbers 
    in a rows by cols matrix, also round it to two digits.
    """
    return [[round(np.random.uniform(0, 1),2) for _ in range(cols)] for _ in range(rows)]

# sidebar components
form_sidebar = st.sidebar.form(key="options")
form_sidebar .header("Grid Size")
width = form_sidebar .number_input("Select a width", value=4, min_value=1, max_value=255, step=1)
height = form_sidebar .number_input("Select a height", value=4, min_value=1, max_value=255, step=1)
buttonSubmit = form_sidebar.form_submit_button("Submit")

# initialize dataframe to be displayed 
# also generate new dataframe when submit button is pressed
if "df" not in st.session_state or buttonSubmit :
    st.session_state.df = pd.DataFrame(
    generate_list_of_lists(height,width), columns=("%d" % i for i in range(width))
    )

# title and header for the page
st.title("Self Check 4")
st.header("Edit Camera View")

# showing the data frame, it can be edited and reflect on figure when displayed
if not st.session_state.df.empty:
    st.session_state.df = st.data_editor(st.session_state.df)

# figure related, size axes, pixels are reversed to highest is black and lowest is white
# note as the implementation is, no matter how big the numbers are, the highest will always be black and the lowest will always be white even when they are not close to or beyond 1 or 0.
figure = plt.figure(figsize=(5,5))
axes = figure.add_subplot(1, 1, 1)
pixels = 1 - st.session_state.df
axes.set_title( "Camera View")
axes.imshow(pixels, cmap='gray')

# display button when pressed to show the figure
buttonDisplay = st.button("Display")

if buttonDisplay:
   st.pyplot(figure)

