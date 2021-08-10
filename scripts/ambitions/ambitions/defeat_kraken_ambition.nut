this.defeat_kraken_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.defeat_kraken";
		this.m.Duration = 35.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Il y a des rumeurs sur une bête colossale qui se cache dans les marais.\n Si nous la trouvons et la tuons, la gloire éternelle sera notre récompense !";
		this.m.UIText = "Vaincre un Kraken";
		this.m.TooltipText = "Vaincre un Kraken au combat. Vous le trouverez quelque part, dans la nature.";
		this.m.SuccessText = "[img]gfx/ui/events/event_89.png[/img]Dans vos rêves, il habite, une tête bulbeuse et lisse, couverte de nénuphars et de plantes médicinales, et son souffle soulève la boue comme le gargarisme du bouillon d\'un chaudron. Ses tentacules se tordent dans la pénombre comme des ombres sur des ombres. Il en est ainsi ici, dans l\'obscurité la plus lointaine, un vide dans lequel il s\'est taillé une place et est devenu une horreur oisive. Quand il apparaît dans vos rêves, c\'est parce que vous y êtes allé. Vous entrez dans l\'obscurité et faites un pas en avant, la main tendue, mais c\'est tout ce que vous faites. Vous ne vous en approchez jamais vraiment. Parfois, vos rêves parlent d\'autre chose, mais vous savez que la bête est là, quelque part, qu\'il vous suffit d\'ouvrir une porte ou de descendre quelques marches pour la retrouver, elle et son domaine. Vous n\'avez pas besoin de parler à vos hommes pour savoir qu\'ils en rêvent aussi.\n\n Le monde a appris que vous avez tué le kraken, mais ils ne voient que des ouï-dire, ils ne voient que la langue d\'une mère qui précipite son enfant au lit, ou un père qui encourage ses proches en parlant du triomphe de l\'homme sur la terreur. Mais ils ne le voient pas. Ils voient la rumeur, pas le monstre, et ils considèrent %companyname% comme des légendes vivantes. Et comme les légendes, chaque jour, les hommes de la compagnie disparaissent des contes et sont remplacés par de véritables héros, chaque coin de la terre façonnant un plus valeureux vainqueur de la créature. Un simple mercenaire n\'aurait jamais bravé une telle bête, disent-ils ! C\'était les chevaliers de l\'est ! La Garde Royale du Nord ! La vanité a pris votre place. Mais les frères avec lesquels vous vous battez connaissent la vérité, et même une vérité mourante est assez bonne pour s\'en sortir. Ainsi, c\'est là, dans l\'obscurité, qu\'il réside, et c\'est là que vous lui rendez souvent visite.";
		this.m.SuccessButtonText = "Quel autre chasseur peut prétendre à un tel exploit ?";
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		if (this.World.getTime().Days <= 100)
		{
			return;
		}

		if (this.World.Ambitions.getDone() < 20)
		{
			return;
		}

		if (this.World.Flags.get("IsKrakenDefeated"))
		{
			this.m.IsDone = true;
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (this.World.Flags.get("IsKrakenDefeated"))
		{
			return true;
		}

		return false;
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

