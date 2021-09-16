this.rangers_intro_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.rangers_scenario_intro";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_10.png[/img]Despite tales of lone hungry hunters just looking to feed a family, poachers often work in teams and create whole businesses out of the trade of stolen furs and meats.\n\nBut as your local lord, %noble%, became increasingly annoyed with poachers hunting in his woods, most of the surrounding groups of hunters were caught, mutilated, and hanged. With just yourself, %hunter1%, %hunter2%, and %hunter3% remaining, a decision had to be made - how to make a living when all you know is how to use a bow?\n\nIt was decided to turn your collective talents to mercenary work, and you were promptly elected captain of the outfit.%SPEECH_ON%You have the sharpest eyes of us all.%SPEECH_OFF%%hunter2% said, and %hunter3% agreed, though tempered it.%SPEECH_ON%And you are, of course, easily the worst shot of the group. Don\'t whip for that one, CAPTAIN, ha-haaa!%SPEECH_OFF%Certainly, your merry band of poachers brings unique talents to the table - your men prefer to travel light, but they are quick on their feet, good shots with a bow and experts in scouting to avoid unfavorable engagements.",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "We\'ll do just fine.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = "ui/banners/" + this.World.Assets.getBanner() + "s.png";
				local brothers = this.World.getPlayerRoster().getAll();
				this.Characters.push(brothers[1].getImagePath());
				this.Characters.push(brothers[2].getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		return;
	}

	function onPrepare()
	{
		this.m.Title = "A Band of Poachers";
	}

	function onPrepareVariables( _vars )
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local settlements = this.World.EntityManager.getSettlements();
		local closest;
		local distance = 9999;

		foreach( s in settlements )
		{
			local d = s.getTile().getDistanceTo(this.World.State.getPlayer().getTile());

			if (d < distance)
			{
				closest = s;
				distance = d;
			}
		}

		local f = closest.getFactionOfType(this.Const.FactionType.NobleHouse);
		_vars.push([
			"hunter1",
			brothers[0].getName()
		]);
		_vars.push([
			"hunter2",
			brothers[1].getName()
		]);
		_vars.push([
			"hunter3",
			brothers[2].getName()
		]);
		_vars.push([
			"noble",
			f.getRandomCharacter().getName()
		]);
	}

	function onClear()
	{
	}

});

