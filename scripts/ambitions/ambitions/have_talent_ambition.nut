this.have_talent_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.have_talent";
		this.m.Duration = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Nous avons besoin de vrais talents pour renforcer nos rangs. Nous recruterons \nle plus talentueux que nous pourrons trouver et le transformerons en dieu de la guerre !";
		this.m.UIText = "Avoir un personnage avec trois fois trois étoiles de talent";
		this.m.TooltipText = "Ayez un personnage dans votre liste avec un talent de trois étoiles dans trois attributs différents. Parcourez le pays et recherchez les meilleurs des meilleurs. Envisagez d\'embaucher le \"Recruteur\" dans votre escorte qui ne combat pas.";
		this.m.SuccessText = "[img]gfx/ui/events/event_82.png[/img]Lorsque le mineur trouve un diamant dans les montagnes, il s\'empresse de l\'emmener dans les chambres royales. Quand le pêcheur remonte la plus grosse prise du jour, c\'est pour un noble. De bons soldats ? Aux seigneurs comme généraux ou entraîneurs. Des tailleurs talentueux ? Les plus belles parures requièrent les doigts les plus fins, pour les nobles qu\'il va servir. Un maître de chien montre un peu d\'habileté au-delà des coups de nez et des ordres d\'aboiement ? Il peut former des chiens de garde pour les armées des nobles. C\'est ainsi que ce monde s\'empare du talent aussi vite que le faucon se jette sur le lapin qui se révèle. Mais maintenant vous avez votre propre talent: %star%. C\'est un véritable génie, qui montre des aptitudes remarquables en matière de physique, d\'habileté martiale et de courage. Même le reste de %companyname% peut sentir la présence de l\'homme aussi sûrement que l\'on sent le destin et la grandeur.\'%star% est tout ce que l\'on peut attendre d\'un mercenaire, et si la compagnie était entièrement composée d\'hommes de sa trempe, eh bien, vous feriez plus que courir les contrats, vous conquerriez le monde entier !";
		this.m.SuccessButtonText = "A moins, bien sûr, qu\'une flèche perdue ne l\'atteigne à la prochaine bataille.";
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

