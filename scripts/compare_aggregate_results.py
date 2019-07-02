import argparse
import csv

parser = argparse.ArgumentParser(
    description="Compares two CSV aggregate results files")
parser.add_argument("first_run_results_file",
                    help="CSV results of the earlier performance run")
parser.add_argument(
    "second_run_results_file",
    help="CSV results of performance run to compare to the first run")
parser.add_argument("output_file", nargs="?", default="comparison_results.txt",
                    help="Optional filename for output of comparison")
args = parser.parse_args()


def parse_csv(filename):
    results = {}
    with open(filename, "r") as file:
        reader = csv.DictReader(file, delimiter=",")
        for row in reader:
            request_label = row["Label"]
            if "token" in request_label:
                continue
            results[request_label] = row

    return results


older_results = parse_csv(args.first_run_results_file)
newer_results = parse_csv(args.second_run_results_file)

with open(args.output_file, "w") as file:
    file.write(f'Comparing {args.first_run_results_file} to '
               f'{args.second_run_results_file}\n\n')
    for request, results in newer_results.items():
        old_results = older_results.get(request)
        if not old_results:
            print(f'No previous results for {request}')
            file.write(f'No previous results for {request}\n')
            continue
        old_average = int(old_results.get("Average"))
        new_average = int(results.get("Average"))
        difference = new_average - old_average
        percent_change = (difference/old_average) * 100
        comparison = (f'{request}\n\t'
                      f'Old Average: {old_average} ms\n\t'
                      f'New Average: {new_average} ms\n\t'
                      f'Difference: {difference} ms\n\t'
                      f'Change: {percent_change:.2f}%\n')
        print(comparison)
        file.write(comparison)
