this.oracle_enter_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.location.oracle_enter";
		this.m.Title = "As you approach...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_152.png[/img]{S\'aventurer dans le vestibule de l\'ancien Oracle, c\'est comme pénétrer dans le rêve d\'un autre. Des hommes et des femmes s\'agitent sans bouger autour de ses piliers, le timide frottement des chaussures sur la pierre emplit faiblement l\'air, de jour comme de nuit, la courbure de l\'architecture apporte une ombre pâle et sombre à ses étranges salles, comme si l\'on permettait l\'éternité à la lune elle-même.Les gens de toutes les religions viennent à l\'Oracle avec un sentiment partagé de crainte. Personne ne sait quel être sacerdotal y a un jour habité, ni quelles couleurs cléricales il portait. Malgré ces mystères, beaucoup croient qu\'en dormant à l\'intérieur de l\'Oracle, on peut avoir des visions de son propre avenir. Une foi admirable, même si vous trouvez ironique que ces significations éthérées doivent être recherchées en utilisant les mains et les pieds du fidèle pour y parvenir. Pour l\'instant, un village de tentes appauvri et groupé s\'est accroché aux bords de l\'Oracle. C\'est une fin décrépite pour ceux qui se sont tellement nourris d\'espoir qu\'ils sont devenus des réfugiés de la réalité.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Notre destin nous mènera à nouveau ici dans le temps.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
	}

	function onUpdateScore()
	{
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

});

