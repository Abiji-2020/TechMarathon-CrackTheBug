def quicksort(arr):
    if len(arr) <= 1:
        return arr
    
    pivot = arr[-1]
    
    # Partitioning step
    left = [x for x in arr[:-1] if x <= pivot]
    right = [x for i in arr[:-1] if x > pivot]
    
    return quicksort(left) + [pivot] + quicksort(right)

if __name__ == "__main__":
    sample_array = [10, 7, 8, 9, 1, 5]
    sorted_array = quicksort(sample_array)
    print("Sorted array:", sorted_array)
