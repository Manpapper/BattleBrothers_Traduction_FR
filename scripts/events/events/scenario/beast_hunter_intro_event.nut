this.beast_hunter_intro_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.beast_hunters_scenario_intro";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_124.png[/img]You met the man in his home. He offered food, drink, and the contract at hand. Kill the witch of the forest and you\'ll be paid in sum. You and your men set out and did just that, bringing back the wench\'s head.\n\nBut your employer only laughed upon your return. He said it was the witch who put him in power and that you had freed him of his debts to her, that he outsmarted you and your stupid men. His lackeys stepped out of the shadows, their swords already drawn. The ambush started upon the criminal\'s arrogance and ended with his head cleared from his shoulders. But it came at the cost of many of your fellow beast slayers, leaving only yourself, %bs1%, %bs2%, and %bs3% remaining.\n\n Monsters of this world are often kept out of sight: the cruelties of man hide behind blind allegiance, the horrors of beasts behind dark legends. As the leader of a band of beast slayers, it has become steadily more apparent that you can no longer differentiate between the two. If you are to make coin hunting creatures, then you might as well add more to the pot by adding man to the ledger.",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "The most wicked beast is the one that thinks itself more.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = "ui/banners/" + this.World.Assets.getBanner() + "s.png";
			}

		});
	}

	function onUpdateScore()
	{
		return;
	}

	function onPrepare()
	{
		this.m.Title = "The Beast Slayers";
	}

	function onPrepareVariables( _vars )
	{
		local brothers = this.World.getPlayerRoster().getAll();
		_vars.push([
			"bs1",
			brothers[0].getNameOnly()
		]);
		_vars.push([
			"bs2",
			brothers[1].getNameOnly()
		]);
		_vars.push([
			"bs3",
			brothers[2].getNameOnly()
		]);
	}

	function onClear()
	{
	}

});

