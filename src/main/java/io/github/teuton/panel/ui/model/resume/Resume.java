package io.github.teuton.panel.ui.model.resume;

import com.google.gson.annotations.SerializedName;

import io.github.teuton.panel.ui.model.cases.Case;
import javafx.beans.property.ListProperty;
import javafx.beans.property.MapProperty;
import javafx.beans.property.ObjectProperty;
import javafx.beans.property.SimpleListProperty;
import javafx.beans.property.SimpleMapProperty;
import javafx.beans.property.SimpleObjectProperty;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.collections.ObservableMap;

public class Resume {

	@SerializedName("config")
	private MapProperty<String, Object> config = new SimpleMapProperty<String, Object>(
			FXCollections.observableHashMap());

	@SerializedName("cases")
	private ListProperty<Case> cases = new SimpleListProperty<>(FXCollections.observableArrayList());

	@SerializedName("results")
	private ObjectProperty<Results> results = new SimpleObjectProperty<>(new Results());

	@SerializedName("hall_of_fame")
	private MapProperty<String, String> hallOfFame = new SimpleMapProperty<String, String>(
			FXCollections.observableHashMap());
	
	public final MapProperty<String, Object> configProperty() {
		return this.config;
	}

	public final ObservableMap<String, Object> getConfig() {
		return this.configProperty().get();
	}

	public final void setConfig(final ObservableMap<String, Object> config) {
		this.configProperty().set(config);
	}

	public final ObjectProperty<Results> resultsProperty() {
		return this.results;
	}

	public final Results getResults() {
		return this.resultsProperty().get();
	}

	public final void setResults(final Results results) {
		this.resultsProperty().set(results);
	}

	public final MapProperty<String, String> hallOfFameProperty() {
		return this.hallOfFame;
	}

	public final ObservableMap<String, String> getHallOfFame() {
		return this.hallOfFameProperty().get();
	}

	public final void setHallOfFame(final ObservableMap<String, String> hallOfFame) {
		this.hallOfFameProperty().set(hallOfFame);
	}

	public final ListProperty<Case> casesProperty() {
		return this.cases;
	}

	public final ObservableList<Case> getCases() {
		return this.casesProperty().get();
	}

	public final void setCases(final ObservableList<Case> cases) {
		this.casesProperty().set(cases);
	}

}
