this.have_talent_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.have_talent";
		this.m.Duration = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "We need real talent to bolster our ranks further.\nWe\'ll recruit the most talented we can find and mold him into a god of war!";
		this.m.UIText = "Have a character with three times three talent stars";
		this.m.TooltipText = "Have a character in your roster with a three stars talent at three different attributes. Travel the land and seek the best of the best. Consider hiring the \'Recruiter\' for your retinue of non-combat followers.";
		this.m.SuccessText = "[img]gfx/ui/events/event_82.png[/img]When the miner find a diamond in the mountains, it is hurried away to the royal chambers. When the fisherman hauls the fattest catch of the day, a nobleman will have it himself. Good soldiers? To the lords as generals or trainers. Talented tailors? The finest fineries require the finest fingers, to the nobles he goes to serve. Houndmaster shows a bit of skill beyond bopping noses and barking commands? He can train wardogs for the highborn armies. So it is that this world snatches the talented as fast as the hawk pounces the rabbit which reveals itself.\n\n But now you\'ve your own catch: %star%. He is a genuine talent, showing remarkable aptitude in physicality, martial skills, and courage. Even the rest of the %companyname% can sense the man\'s presence as sure as one sense destiny and greatness. %star% is everything you\'d want in a mercenary, and were the company fitted entirely with a man of his mold, well, you\'d do more than chase contracts, you\'d conquer the whole world!";
		this.m.SuccessButtonText = "Unless, of course, a stray arrow catches him next battle.";
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		if (this.World.getTime().Days <= 100)
		{
			return;
		}

		if (this.World.Ambitions.getDone() < 3)
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone())
		{
			return;
		}

		if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax() - 1)
		{
			return;
		}

		local roster = this.World.getPlayerRoster().getAll();

		foreach( bro in roster )
		{
			local n = 0;

			foreach( t in bro.getTalents() )
			{
				if (t == 3)
				{
					n = ++n;
				}
			}

			if (n >= 3)
			{
				return;
			}
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		local roster = this.World.getPlayerRoster().getAll();

		foreach( bro in roster )
		{
			local n = 0;

			foreach( t in bro.getTalents() )
			{
				if (t == 3)
				{
					n = ++n;
				}
			}

			if (n >= 3)
			{
				return true;
			}
		}

		return false;
	}

	function onPrepareVariables( _vars )
	{
		local roster = this.World.getPlayerRoster().getAll();
		local star;

		foreach( bro in roster )
		{
			local n = 0;

			foreach( t in bro.getTalents() )
			{
				if (t == 3)
				{
					n = ++n;
				}
			}

			if (n >= 3)
			{
				star = bro;
				break;
			}
		}

		_vars.push([
			"star",
			star.getName()
		]);
	}

	function onSerialize( _out )
	{
		this.ambition.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.ambition.onDeserialize(_in);
	}

});

